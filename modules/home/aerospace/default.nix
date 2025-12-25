let
  config = {
    after-login-command = [ ];
    after-startup-command = [ ];
    enable-normalization-flatten-containers = true;
    enable-normalization-opposite-orientation-for-nested-containers = true;
    accordion-padding = 50;
    default-root-container-layout = "tiles";
    default-root-container-orientation = "auto";
    on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
    automatically-unhide-macos-hidden-apps = true;
    key-mapping.preset = "qwerty";

    gaps = {
      inner = {
        horizontal = 5;
        vertical = 5;
      };
      outer = {
        left = 5;
        bottom = 5;
        top = 5;
        right = 5;
      };
    };

    mode.main.binding = {
      # Terminal (doesn't work, also wnat this.)
      # alt-enter = ''
      #   exec-and-forget osascript -e '
      #   tell application "Ghostty"
      #       do script
      #       activate
      #   end tell'
      # '';

      # Layout
      alt-slash = "layout tiles horizontal vertical";
      alt-comma = "layout accordion horizontal vertical";

      # Focus
      alt-h = "focus left";
      alt-j = "focus down";
      alt-k = "focus up";
      alt-l = "focus right";

      # Move
      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";

      # Resize
      alt-shift-minus = "resize smart -50";
      alt-shift-equal = "resize smart +50";

      # Workspaces (alt-1 through alt-9 and alt-q through alt-o)
      alt-1 = "workspace 1";
      alt-q = "workspace q";
      alt-shift-1 = "move-node-to-workspace 1";
      alt-shift-q = "move-node-to-workspace q";
      alt-2 = "workspace 2";
      alt-w = "workspace w";
      alt-shift-2 = "move-node-to-workspace 2";
      alt-shift-w = "move-node-to-workspace w";
      alt-3 = "workspace 3";
      alt-e = "workspace e";
      alt-shift-3 = "move-node-to-workspace 3";
      alt-shift-e = "move-node-to-workspace e";
      alt-4 = "workspace 4";
      alt-r = "workspace r";
      alt-shift-4 = "move-node-to-workspace 4";
      alt-shift-r = "move-node-to-workspace r";
      alt-5 = "workspace 5";
      alt-t = "workspace t";
      alt-shift-5 = "move-node-to-workspace 5";
      alt-shift-t = "move-node-to-workspace t";
      alt-6 = "workspace 6";
      alt-y = "workspace y";
      alt-shift-6 = "move-node-to-workspace 6";
      alt-shift-y = "move-node-to-workspace y";
      # alt-7 = "workspace 7";
      # alt-u = "workspace u";
      # alt-shift-7 = "move-node-to-workspace 7";
      # alt-shift-u = "move-node-to-workspace u";
      # alt-8 = "workspace 8";
      # alt-i = "workspace i";
      # alt-shift-8 = "move-node-to-workspace 8";
      # alt-shift-i = "move-node-to-workspace i";
      # alt-9 = "workspace 9";
      # alt-o = "workspace o";
      # alt-shift-9 = "move-node-to-workspace 9";
      # alt-shift-o = "move-node-to-workspace o";

      # Workspace Management
      alt-tab = "workspace-back-and-forth";
      alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
      alt-shift-semicolon = "mode service";

      cmd-h = [ ]; # Disable "hide application"
      cmd-alt-h = [ ]; # Disable "hide others"
    };

    mode.service.binding = {
      esc = [
        "reload-config"
        "mode main"
      ];
      r = [
        "flatten-workspace-tree"
        "mode main"
      ];
      f = [
        "layout floating tiling"
        "mode main"
      ];
      backspace = [
        "close-all-windows-but-current"
        "mode main"
      ];
      alt-shift-h = [
        "join-with left"
        "mode main"
      ];
      alt-shift-j = [
        "join-with down"
        "mode main"
      ];
      alt-shift-k = [
        "join-with up"
        "mode main"
      ];
      alt-shift-l = [
        "join-with right"
        "mode main"
      ];
    };

    # Doesn't work :/
    on-window-detected = [
      {
        "if" = {
          app-id = "pl.maketheweb.cleanshotx";
        };
        run = [ "layout floating" ];
      }
      {
        "if" = {
          # app-name-regex-su = "Firefox";
          window-title-regex-substring = "Picture-in-Picture";
        };
        "run" = [ "layout floating" ];
      }
    ];
  };

  # [[on-window-detected]]
  #     if.app-id = 'org.alacritty'
  #     run = 'move-node-to-workspace T' # mnemonics T - Terminal
  #
  # [[on-window-detected]]
  #     if.app-id = 'com.google.Chrome'
  #     run = 'move-node-to-workspace W' # mnemonics W - Web browser
  #
  # [[on-window-detected]]
  #     if.app-id = 'com.jetbrains.intellij'
  #     run = 'move-node-to-workspace I' # mnemonics I - IDE
in
{
  services.aerospace = {
    enable = true;
    settings = config;
  };
}
