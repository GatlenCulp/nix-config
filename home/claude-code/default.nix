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
    enable = true;
    servers = mcpServers;
  };
}
