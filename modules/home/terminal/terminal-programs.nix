{
  pkgs,
  inputs,
  secrets,
}:
{
  bat = {
    enable = true;
    config = {
      theme = "Dracula";
      pager = "ov -F -H3";
    };
    # Run with --impure bc not changing this yet lol
    # themes.Dracula.src = "/Users/gat/.config/nix-darwin/assets/Dracula.tmTheme";
    # themes.dracula = {
    #   # TODO: learn about this more generally. ALso just does not work oops.
    #   src = pkgs.fetchFromGitHub {
    #     owner = "dracula";
    #     repo = "sublime";
    #     rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
    #     sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
    #   };
    #   file = "Dracula.tmTheme";
    # };
  };

  eza = {

    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    extraOptions = [
      "--width=100"
      "--group-directories-first"
      "--all"
    ];
    git = true;
    icons = "auto";
    theme = "dracula";
  };

  tealdeer.enable = true;
  fzf.enable = true;
  fd.enable = true;

  yazi.enable = true;
  zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
  tex-fmt.enable = true;
  sqls.enable = true;
  readline.enable = true;
  ripgrep.enable = true;
  ripgrep-all.enable = true;

  # Additional terminal programs
  zed-editor.enable = true;

  pandoc.enable = true;
  direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  # System Monitoring & Utilities
  btop.enable = true;
  less.enable = true;
  emacs = {
    enable = true;
  };

  tmux.enable = true;

  delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      file-style = "yellow";
      ov-diff = {
        pager = "ov -F --section-delimiter '^(commit|added:|removed:|renamed:|Δ)' --section-header --pattern '•'";
      };
      ov-log = {
        pager = "ov -F --section-delimiter '^commit' --section-header-num 3";
      };
    };
  };

  gh = {
    enable = true;
    # gitCredentialHelper.enable = true;
    # hosts = {
    #   "github.com" = { user = "GatlenCulp"; };
    #   settings = { git_protocol = "ssh"; };
    # };
  };

  jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "GatlenCulp@gmail.com";
        name = "Gatlen Culp";
      };
      ui = {
        default-command = "log";
      };
      snapshot = {
        max-new-file-size = "5MiB";
      };
      # Perhaps may want to add pager?
    };
  };

  # Programming Environment
  awscli = {
    enable = true;
    settings = secrets.awscli.settings;
    credentials = secrets.awscli.credentials;
  };
  bun = {
    enable = true;
    enableGitIntegration = true;
  };
  mise = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };
  nh.enable = true;
  nix-index = {
    enable = true;
    enableBashIntegration = true;
  };
  poetry.enable = true;
  uv.enable = true;

  # Editors
  helix.enable = true;
  nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  neovide = {
    enable = true;
  };

  # Network & Security


  go.enable = true;

  # grep.enable = true; #not available?
}
