#!/usr/bin/env bash
# Register this repo's MCP servers with Claude Code at USER scope.
#
# Why this exists: Claude Code is installed from the `claude-code` Homebrew cask
# (see modules/darwin/homebrew.nix), so there is no longer a Nix wrapper to
# inject `--mcp-config=<repo>/mcp.json` -- and one could not be re-added, since
# /opt/homebrew/bin precedes the home-manager profile on PATH. User-scope
# registration is the replacement: it lands in ~/.claude.json and so applies to
# every `claude` invocation, including the one claude-code.nvim spawns.
#
# mcp.json beside this file stays the checked-in source of truth that this
# script replays. ~/.claude.json is runtime-managed and NOT tracked by Nix, so
# re-run this after a factory reset (or after editing mcp.json):
#
#     bash home/claude-code/register-mcp.sh
#
# Idempotent: each server is removed before being re-added, so re-running just
# resyncs ~/.claude.json to mcp.json.
#
# NOTE: `env` values in mcp.json are ${VAR} placeholders that Claude Code
# expands from the shell environment at server launch (exported from secrets by
# home/shells). They are stored unexpanded, so no tokens land in ~/.claude.json.
set -euo pipefail

mcp_json="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/mcp.json"
[[ -f $mcp_json ]] || { echo "error: $mcp_json not found" >&2; exit 1; }
command -v claude >/dev/null || { echo "error: claude not on PATH (brew install --cask claude-code)" >&2; exit 1; }

# Emit "<name>\t<compact server json>" per server, tab-separated.
while IFS=$'\t' read -r name spec; do
  [[ -n $name ]] || continue
  echo "==> $name"
  claude mcp remove -s user "$name" >/dev/null 2>&1 || true
  claude mcp add-json -s user "$name" "$spec"
done < <(python3 -c '
import json, sys
servers = json.load(open(sys.argv[1]))["mcpServers"]
for name, spec in servers.items():
    print(name, json.dumps(spec, separators=(",", ":")), sep="\t")
' "$mcp_json")

echo
echo "Registered at user scope. Verify with: claude mcp list"
