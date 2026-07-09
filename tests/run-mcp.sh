#!/usr/bin/env bash
# Guards for the live-editable Claude MCP config (home/claude-code/mcp.json)
# and its wiring:
#   1. mcp.json is valid JSON with the expected servers.
#   2. NO literal secrets in mcp.json — it is committed to git; secrets must be
#      ${ENV_VAR} references expanded by Claude Code at runtime.
#   3. The claude wrapper points --mcp-config= (equals form) at the LIVE repo
#      path, not a read-only /nix/store path, and the store-baked
#      programs.claude-code.mcpServers option is not used.
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

# --- 3. wrapper uses equals form + live path ---------------------------------
mod=home/claude-code/default.nix
if grep -q -- '--mcp-config=''${flakeDir}/home/claude-code/mcp.json' "$mod"; then
  ok "claude wrapper uses --mcp-config=<live repo path> (equals form)"
else
  fail "claude wrapper does not point --mcp-config= at the live mcp.json"
fi
if grep -qE '^\s*mcpServers\s*=' "$mod"; then
  fail "programs.claude-code.mcpServers is set (store-baked config) — should be unset"
else
  ok "programs.claude-code.mcpServers not used (no store-baked MCP config)"
fi

# --- 4. whatsapp launchd agent evaluates --------------------------------------
out=$(nix eval --impure --json --expr '
  let
    m = import ./home/whatsapp-mcp/default.nix {
      config.home.homeDirectory = "/home/gattest";
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
