# whatsapp-mcp (https://github.com/lharries/whatsapp-mcp) — WhatsApp for
# Claude via MCP. Two pieces:
#
#   1. whatsapp-bridge: a long-running Go process that connects to WhatsApp
#      Web's multi-device API and mirrors messages into a local SQLite DB.
#      Managed here as a launchd agent.
#   2. whatsapp-mcp-server: a Python MCP server (run via `uv`) that Claude
#      talks to. Registered in home/claude-code/mcp.json (live-editable).
#
# Not in nixpkgs and not flake-packaged here on purpose: the project ships
# from a moving main branch and the bridge needs an INTERACTIVE first run
# (QR code scan) to pair with your phone. One-time setup:
#
#   git clone https://github.com/lharries/whatsapp-mcp ~/whatsapp-mcp
#   cd ~/whatsapp-mcp/whatsapp-bridge && go run main.go   # scan the QR code
#
# After pairing, the launchd agent below keeps the bridge running across
# logins. `go` comes from home/_go (programs.go), `uv` from home/_python
# (programs.uv) — both already enabled on gatty.
{ config, pkgs, ... }:
let
  bridgeDir = "${config.home.homeDirectory}/whatsapp-mcp/whatsapp-bridge";
  logFile = "${config.home.homeDirectory}/Library/Logs/whatsapp-bridge.log";
in
{
  launchd.agents.whatsapp-bridge = {
    enable = true;
    config = {
      # go is resolved from the Nix store directly — launchd's login-shell
      # PATH is not guaranteed to include the home-manager profile.
      # Exits 0 (no respawn churn) when the repo has not been cloned yet.
      ProgramArguments = [
        "/bin/bash"
        "-l"
        "-c"
        ''
          if [ ! -d "${bridgeDir}" ]; then
            echo "whatsapp-bridge: ${bridgeDir} not found; clone lharries/whatsapp-mcp and pair first (see home/whatsapp-mcp/default.nix)"
            exit 0
          fi
          cd "${bridgeDir}" && exec ${pkgs.go}/bin/go run main.go
        ''
      ];
      RunAtLoad = true;
      # Respawn on crash, but do not respawn after a clean exit (repo missing).
      KeepAlive = {
        SuccessfulExit = false;
      };
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
    };
  };
}
