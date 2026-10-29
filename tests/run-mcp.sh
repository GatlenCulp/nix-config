#!/usr/bin/env bash
# Guards for the live-editable Claude MCP config (home/claude-code/mcp.json)
# and its wiring:
#   1. mcp.json is valid JSON with the expected servers.
#   2. NO literal secrets in mcp.json — it is committed to git; secrets must be
#      ${ENV_VAR} references expanded by Claude Code at runtime.
#   3. The brew-cask handover holds: the Claude Code CLI comes from the
#      `claude-code` cask, home/claude-code installs no competing Nix copy, and
#      register-mcp.sh replays every mcp.json server at user scope (the
#      replacement for the removed --mcp-config wrapper).
#   4. The whatsapp-mcp launchd agent evaluates and targets the bridge dir.
set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$here/.." && pwd)"
cd "$root"
rc=0
ok() { echo "OK: $1"; }
fail() { echo "FAIL: $1" >&2; rc=1; }

# --- 1. mcp.json shape -------------------------------------------------------
if jq -e '.mcpServers | has("notionApi") and has("github") and has("whatsapp")' \
    home/claude-code/mcp.json >/dev/null 2>&1; then
  ok "mcp.json is valid JSON with notionApi/github/whatsapp servers"
else
  fail "mcp.json missing or malformed (need mcpServers.{notionApi,github,whatsapp})"
fi

# --- 2. no literal secrets ---------------------------------------------------
if grep -qE 'ntn_[A-Za-z0-9]|ghp_[A-Za-z0-9]|github_pat_|<YOUR_TOKEN>|sk-[A-Za-z0-9]{8}' \
    home/claude-code/mcp.json; then
  fail "mcp.json contains what looks like a literal secret — use \${ENV_VAR} references"
else
  ok "mcp.json has no literal secrets (env-var references only)"
fi

# --- 3. brew owns the CLI; MCP servers registered at user scope --------------
# The --mcp-config wrapper is gone: brew puts claude at /opt/homebrew/bin, which
# precedes the home-manager profile on PATH, so a Nix shim could never win the
# lookup. register-mcp.sh writes the servers into ~/.claude.json instead.
mod=home/claude-code/default.nix
reg=home/claude-code/register-mcp.sh

if grep -qE '^\s*"claude-code"' modules/darwin/homebrew.nix; then
  ok "claude-code cask declared in homebrew.nix (brew owns the CLI)"
else
  fail "claude-code cask missing from modules/darwin/homebrew.nix"
fi

# No second bin/claude from Nix: neither programs.claude-code.enable nor a
# symlinkJoin wrapper may come back, or it shadows/collides with the cask.
if grep -qE '^\s*(enable|package)\s*=' "$mod" || grep -q 'symlinkJoin' "$mod"; then
  fail "$mod installs a Nix claude-code again — brew owns the CLI now"
else
  ok "home/claude-code installs no competing Nix claude (settings symlink only)"
fi
if grep -qE '^\s*mcpServers\s*=' "$mod"; then
  fail "programs.claude-code.mcpServers is set (store-baked config) — should be unset"
else
  ok "programs.claude-code.mcpServers not used (no store-baked MCP config)"
fi

# The settings.json symlink is the one thing home/claude-code must still do.
if grep -q 'mkOutOfStoreSymlink' "$mod"; then
  ok "home/claude-code still symlinks settings.json to the live repo file"
else
  fail "$mod no longer symlinks ~/.claude/settings.json at the repo file"
fi

# register-mcp.sh must exist, be user-scoped, and cover every mcp.json server.
if [ -f "$reg" ] && grep -q 'mcp add-json -s user' "$reg"; then
  ok "register-mcp.sh replays mcp.json at user scope"
else
  fail "register-mcp.sh missing or not using 'claude mcp add-json -s user'"
fi
if bash -n "$reg" 2>/dev/null; then
  ok "register-mcp.sh is syntactically valid bash"
else
  fail "register-mcp.sh has a syntax error"
fi

# --- 4. whatsapp launchd agent evaluates --------------------------------------
out=$(nix eval --impure --json --expr '
  let
    m = import ./home/whatsapp-mcp/default.nix {
      config.home.homeDirectory = "/home/gattest";
      pkgs.go = "/mock/go-store-path";
    };
    a = m.launchd.agents.whatsapp-bridge;
  in {
    enabled = a.enable;
    runAtLoad = a.config.RunAtLoad;
    prog = builtins.concatStringsSep " " a.config.ProgramArguments;
  }' 2>&1) || { fail "whatsapp module eval failed: $out"; out='{}'; }
if echo "$out" | jq -e '.enabled == true and .runAtLoad == true and (.prog | contains("whatsapp-mcp/whatsapp-bridge"))' >/dev/null 2>&1; then
  ok "whatsapp-bridge launchd agent enabled and targets the bridge dir"
else
  fail "whatsapp-bridge launchd agent misconfigured: $out"
fi

[ "$rc" -eq 0 ] && echo "ALL GREEN"
exit "$rc"
