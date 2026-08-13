{
  config,
  pkgs,
  inputs,
  ...
}:
let
  flakeDir = "${config.home.homeDirectory}/.config/nix-config";

  # Source the package from the claude-code-nix flake input instead of
  # `pkgs.claude-code`: nixpkgs' copy lags upstream by weeks, and Claude Code
  # ships several releases a week. Same official Anthropic binary, re-pinned
  # hourly. See the input's comment in flake.nix.
  claudeCode = inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

  # MCP servers live in a LIVE-EDITABLE, repo-tracked JSON (mcp.json beside
  # this file) — same pattern as settings.json: edit + restart claude, no
  # rebuild. Secrets are referenced as ''${ENV_VAR} (Claude Code expands env
  # vars in MCP config files); the variables themselves come from the shell
  # environment (exported from secrets via home/shells). NEVER put literal
  # tokens in mcp.json — it is committed to git.
  #
  # The upstream home-manager `programs.claude-code.mcpServers` option is NOT
  # used: it bakes the config into the read-only /nix/store AND wraps the
  # binary with the space-separated `--mcp-config <path>` form. Claude's
  # `--mcp-config` is variadic, so it greedily eats the next positional arg,
  # making `claude .` read `.` as a second config file and crash with
  # `EISDIR: illegal operation on a directory`. We wrap the package ourselves
  # with the `--mcp-config=<path>` (equals) form, which binds exactly one
  # value, pointed at the live repo file.
  wrappedClaudeCode = pkgs.symlinkJoin {
    name = "claude-code";
    paths = [ claudeCode ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude --add-flags "--mcp-config=${flakeDir}/home/claude-code/mcp.json"
    '';
    inherit (claudeCode) meta;
  };
in
{
  programs.claude-code = {
    enable = true;
    package = wrappedClaudeCode;
    # `mcpServers` intentionally unset (see wrapper note above).
    # `settings` intentionally unset: Claude Code (and Cursor, which shares
    # the file) rewrites ~/.claude/settings.json at runtime — permission
    # prompts, /config changes, theme — so a read-only Nix store symlink
    # breaks both tools. Settings live in the checked-in, hand-editable JSON
    # symlinked below.
  };

  # Editable settings: symlink straight to the repo file so edits by you OR by
  # Claude/Cursor apply instantly, need no rebuild, and are tracked in git.
  # `force` replaces any settings.json the tools already wrote at that path.
  home.file.".claude/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/claude-code/settings.json";
    force = true;
  };
}
