# Terminal Multiplexers & Session Management
{
  programs.zellij = {
    enable = true;
    # A bit annoying
    # enableBashIntegration = true;
    # enableZshIntegration = true;
    # exitShellOnExit = true;
    settings = {
      theme = "dracula";
      show_startup_tips = false;
      default_shell = "zsh";
      pane_frames = false;
      # simplified_ui = true; # Doesn't actually reduce space. More for fonts.
      default_layout = "dev"; # Puts top bar at the bottom.
      ui.pane_frames.hide_session_name = true;
    };
    layouts = {
      dev = {
        layout = {
          _children = [
            {
              default_tab_template = {
                _children = [
                  { "children" = { }; }
                  {
                    pane = {
                      size = 1;
                      borderless = true;
                      plugin = {
                        location = "zellij:compact-bar";
                      };
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "zsh";
                };
                _children = [
                  {
                    pane = {
                      command = "zsh";
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    };
  };
}
