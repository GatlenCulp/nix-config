{ config, ... }:
let
  flakeDir = "${config.home.homeDirectory}/.config/nix-config";
  # Shared MCP server configurations
  mcpServers = {
    notionApi = {
      command = "npx";
      args = [
        "-y"
        "@notionhq/notion-mcp-server"
      ];
      env = {
        "OPENAPI_MCP_HEADERS" = ''{"Authorization": "Bearer ntn_****", "Notion-Version": "2022-06-28" }'';
      };
    };
    github = {
      command = "wr";
      args = [
        "run"
        "-i"
        "--rm"
        "-e"
        "GITHUB_PERSONAL_ACCESS_TOKEN"
        "ghcr.io/github/github-mcp-server"
      ];
      env = {
        # TODO
        "GITHUB_PERSONAL_ACCESS_TOKEN" = "<YOUR_TOKEN>";
      };
    };
  };

  # The upstream home-manager `programs.claude-code` module wraps the binary with
  # `--mcp-config <path>` (space-separated). Claude's `--mcp-config` is variadic,
  # so it greedily eats the next positional arg. That makes `claude .` read `.`
  # (the cwd, a directory) as a second MCP config file and crash with
  # `EISDIR: illegal operation on a directory`. We instead wrap the package
  # ourselves using the `--mcp-config=<path>` (equals) form, which binds exactly
  # one value, and disable the module's auto-wrapper by leaving `mcpServers = {}`.
  mcpConfig = (pkgs.formats.json { }).generate "claude-code-mcp-config.json" {
    inherit mcpServers;
  };
  wrappedClaudeCode = pkgs.symlinkJoin {
    name = "claude-code";
    paths = [ pkgs.claude-code ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude --add-flags "--mcp-config=${mcpConfig}"
    '';
    inherit (pkgs.claude-code) meta;
  };
in
{
  programs.claude-code = {
    enable = true;
    mcpServers = mcpServers;
    # `settings` is intentionally NOT set here. Claude Code (and Cursor, which
    # shares the file) rewrites ~/.claude/settings.json at runtime — permission
    # prompts, /config changes, theme — so a read-only Nix store symlink breaks
    # both tools. The settings now live in a checked-in, hand-editable JSON file
    # symlinked into place below (see home.file.".claude/settings.json").
  };

  # Editable settings: symlink straight to the repo file so edits by you OR by
  # Claude/Cursor apply instantly, need no rebuild, and are tracked in git.
  # `force` replaces any settings.json the tools already wrote at that path.
  #
  # SECURITY: only non-secret config belongs in settings.json. MCP servers hold
  # token placeholders/secrets and stay in `programs.mcp` — never symlinked here.
  home.file.".claude/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/claude-code/settings.json";
    force = true;
  };

  programs.mcp = {
    enable = false;
    servers = mcpServers;
  };
}
