{ config, ... }:
let
  flakeDir = "${config.home.homeDirectory}/.config/nix-config";
in
{
  # The Claude Code CLI itself is NOT installed from Nix. It comes from the
  # `claude-code` Homebrew cask (modules/darwin/homebrew.nix, AI section), which
  # fetches the same official Anthropic binary the retired claude-code-nix flake
  # input did but tracks upstream on `brew upgrade` instead of a flake re-pin.
  # Claude Code ships several releases a week, so the flake pin stranded us tens
  # of patch versions behind. `programs.claude-code` is therefore left disabled:
  # enabling it would put a second `bin/claude` in the home-manager profile.
  #
  # Consequence: there is no Nix wrapper anymore, so the old
  # `--mcp-config=<repo>/mcp.json` flag injection is gone (and could not be
  # restored -- /opt/homebrew/bin precedes the home-manager profile on PATH, so
  # a Nix-provided `claude` shim would never win). MCP servers are registered at
  # user scope instead, with `claude mcp add -s user <name> -- <cmd>`, which
  # applies to every invocation including the one claude-code.nvim spawns.
  # mcp.json beside this file is kept as the checked-in reference copy of those
  # registrations -- it is no longer read by Claude Code. Re-register after a
  # factory reset with: bash home/claude-code/register-mcp.sh

  # Editable settings: symlink straight to the repo file so edits by you OR by
  # Claude/Cursor apply instantly, need no rebuild, and are tracked in git.
  # Claude Code (and Cursor, which shares the file) rewrites settings.json at
  # runtime -- permission prompts, /config changes, theme -- so a read-only Nix
  # store copy would break both tools.
  # `force` replaces any settings.json the tools already wrote at that path.
  home.file.".claude/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/claude-code/settings.json";
    force = true;
  };
}
