{ pkgs }:
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
        "GITHUB_PERSONAL_ACCESS_TOKEN" = "<YOUR_TOKEN>";
      };
    };
  };
in
{
  # Communication
  thunderbird = {
    enable = true;
    profiles."GatlenCulp@gmail.com" = {
      isDefault = true;
    };
    # Go to settings then about:config
    settings = {
      mailnews.message_display.disable_remote_image = false; # Borderline unusable without remote images unfortunately
      # mail.threadpane.listview = 1; # I think table view instead of list view messages(?)
    };
    # extensions = [  ]; Basically not workable lol
    # Cardbook is better than their regular contacts
    # Auto Profile Picture is also a must-have extension.
    # Thunderbird is kind of ass as a client
  };

  # Copied here
  mbsync.enable = true;
  msmtp.enable = true;
  notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  himalaya = {
    enable = true;
    # package = pkgs.himalaya.override { withNotmuchBackend = true; };
  };

  # Media
  mpv.enable = true;

  # Browsers
  # chromium = { enable = true; }; # Not available on darwin?
  # firefox is now a module imported in homeManagerConfig

  discord = {
    enable = true;
  };

  spotify-player = {
    enable = true;
  };

  rio = {
    enable = true;
    settings = {
      theme = "dracula";
      cursor.blinking = true;
      window.opacity = 0.8;
      fonts = {
        size = 11;
        family = "FiraCode Nerd Font";
      };
      # Doesn't work, supposed to be funky
      renderer.filters = [ "NewPixieCrt" ];
      platform.macos = {
        # Not sure if chosen automatically
        renderer.backend = "Metal";
      };
    };

    themes = {
      "dracula".colors = {
        background = "#282a36";
        black = "#44475a";
        blue = "#bd93f9";
        cursor = "#f8f8f2";
        cyan = "#8be9fd";
        foreground = "#f8f8f2";
        green = "#50fa7b";
        magenta = "#ff79c6";
        red = "#ff5555";
        tabs = "#494c62";
        tabs-active = "#6a6e8e";
        white = "#f8f8f2";
        yellow = "#f1fa8c";
        dim-black = "#393c4b";
        dim-blue = "#ae7bf8";
        dim-cyan = "#69c3de";
        dim-foreground = "#dfdfd9";
        dim-green = "#06572f";
        dim-magenta = "#ff60bb";
        dim-red = "#ff3c3c";
        dim-white = "#efefe1";
        dim-yellow = "#e6a003";
        light-black = "#6272a4";
        light-blue = "#d6acff";
        light-cyan = "#a4ffff";
        light-foreground = "#f8f8f1";
        light-green = "#69ff94";
        light-magenta = "#ff92df";
        light-red = "#ff6e6e";
        light-white = "#ffffff";
        light-yellow = "#ffffa5";
      };
    };
  };

  # Oddly not in packages?
  desktoppr = {
    enable = true;
    settings = {
      picture = /Users/gat/.config/nix-config/assets/wallpaper-cyberpunk.jpg;
    };
  };

  zed-editor.enable = true;
  obsidian = {
    # https://github.com/nix-community/home-manager/pull/6487
    enable = true;
    defaultSettings = {
    };
    vaults = {
      "obsidian-main-vault-test" = {
        enable = true;
      };
    };

  };
  fabric-ai = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  claude-code = {
    enable = true;
    mcpServers = mcpServers;
    settings = {
      hooks = {
        PostToolUse = [
          {
            hooks = [
              {
                command = "file=$(jq -r '.tool_input.file_path' <<<
  '$CLAUDE_TOOL_INPUT'); [[ \"$file\" == *.nix ]] && nix fmt \"$file\" || true";
                type = "command";
              }
              {
                command = "file=$(jq -r '.tool_input.file_path' <<<
  '$CLAUDE_TOOL_INPUT'); [[ \"$file\" == *.py ]] && ruff format \"$file\" && ruff check --fix || true";
                type = "command";
              }
            ];
            matcher = "Edit|MultiEdit|Write";
          }
        ];
        PreToolUse = [
          {
            hooks = [
              {
                command = "echo 'Running command: $CLAUDE_TOOL_INPUT'";
                type = "command";
              }
            ];
            matcher = "Bash";
          }
        ];
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

  mcp = {
    enable = true;
    servers = mcpServers;
  };
}
