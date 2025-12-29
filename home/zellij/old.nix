# Terminal Multiplexers & Session Management
# Kind of hard to configure zellij with nix, so will just link the config file.
let
  shellAliases = {
    "zj" = "zellij";
  };
in
{
  home.shellAliases = shellAliases;
  programs.nushell.shellAliases = shellAliases;

  programs.tmux.enable = false;

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;

  programs.zellij = {
    enable = true;
    # Do I need to write package = pkgs.zellij?
  };

  # programs.zellij = {
  #   enable = true;
  #   # A bit annoying
  #   # enableBashIntegration = true;
  #   # enableZshIntegration = true;
  #   # exitShellOnExit = true;
  #   settings = {
  #     theme = "dracula";
  #     show_startup_tips = false;
  #     default_shell = "zsh";
  #     pane_frames = false;
  #     # simplified_ui = true; # Doesn't actually reduce space. More for fonts.
  #     default_layout = "dev"; # Puts top bar at the bottom.
  #     ui.pane_frames.hide_session_name = true;
  #   };
  #   layouts = {
  #     dev = {
  #       layout = {
  #         _children = [
  #           {
  #             default_tab_template = {
  #               _children = [
  #                 { "children" = { }; }
  #                 {
  #                   pane = {
  #                     size = 1;
  #                     borderless = true;
  #                     plugin = {
  #                       location = "zellij:compact-bar";
  #                     };
  #                   };
  #                 }
  #               ];
  #             };
  #           }
  #           {
  #             tab = {
  #               _props = {
  #                 name = "zsh";
  #               };
  #               _children = [
  #                 {
  #                   pane = {
  #                     command = "zsh";
  #                   };
  #                 }
  #               ];
  #             };
  #           }
  #         ];
  #       };
  #     };
  #   };
  # };

  # # # auto start zellij in nushell
  # # programs.nushell.extraConfig = ''
  # #   # auto start zellij
  # #   # except when in emacs or zellij itself
  # #   if (not ("ZELLIJ" in $env)) and (not ("INSIDE_EMACS" in $env)) {
  # #     if "ZELLIJ_AUTO_ATTACH" in $env and $env.ZELLIJ_AUTO_ATTACH == "true" {
  # #       ^zellij attach -c
  # #     } else {
  # #       ^zellij
  # #     }

  # #     # Auto exit the shell session when zellij exit
  # #     $env.ZELLIJ_AUTO_EXIT = "false" # disable auto exit
  # #     if "ZELLIJ_AUTO_EXIT" in $env and $env.ZELLIJ_AUTO_EXIT == "true" {
  # #       exit
  # #     }
  # #   }
  # '';
}
