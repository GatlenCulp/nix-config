{ ... }:
let
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
    settings = {
      hooks = {
        PostToolUse = [
          {
            hooks = [
              {
                command = "file=$(jq -r '.tool_input.file_path'); [[ \"$file\" == *.nix ]] && nix fmt \"$file\" || true";
                type = "command";
              }
              {
                command = "file=$(jq -r '.tool_input.file_path'); [[ \"$file\" == *.py ]] && ruff format \"$file\" && ruff check --fix \"$file\" || true";
                type = "command";
              }
            ];
            matcher = "Edit|MultiEdit|Write";
          }
        ];
        # NOTE: Do NOT add a PreToolUse hook that writes plain text to stdout
        # (e.g. `jq -r '"Running command: " + .tool_input.command'`). Cursor
        # shares this settings.json and parses hook stdout as JSON, so any
        # non-JSON output blocks every agent shell command. If you need such a
        # hook, emit valid JSON or redirect output to stderr (`... >&2`).
        PreToolUse = [ ];
      };
      includeCoAuthoredBy = false;
      permissions = {
        # additionalDirectories = [ "../docs/" ]; Add personal files?
        allow = [
          "Edit"
          "Bash(cursor:*)"
          "Bash(find:*)"
          "Bash(git diff:*)"
          "Bash(git mv:*)"
          "Bash(ls:*)"
          "Bash(grep:*)"
          "Bash(md5:*)"
          "Bash(mkdir:*)"
        ];
        ask = [
          "Bash(git push:*)"
          "Bash(uv run python:*)"
          "Bash(python3:*)"
        ];
        defaultMode = "acceptEdits";
        deny = [
          "Read(./.env)"
          "Read(./secrets/**)"
        ];
        disableBypassPermissionsMode = "disable";
      };
      statusLine = {
        command = "bunx ccstatusline@latest";
        padding = 0;
        type = "command";
      };
      theme = "dark";
    };
  };

  programs.mcp = {
    enable = true;
    servers = mcpServers;
  };
}
