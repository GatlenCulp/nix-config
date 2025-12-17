{
  pkgs,
  inputs,
  secrets,
}:
{
  # Shell & Navigation
  atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      inline_height = 18;
      max_preview_height = 1;
      theme.name = "dracula";
    };
    themes.dracula = {
      theme.name = "Dracula";
      colors = {
        AlertError = "#FF6E6E";
        AlertInfo = "#D6ACFF";
        AlertWarn = "#FFFFA5";
        Annotation = "#6272A4";
        Base = "#F8F8F2";
        Guidance = "#50FA7B";
        Important = "#A4FFFF";
        Title = "#ABB2BF";
      };
    };
  };

  bat = {
    enable = true;
    config = {
      theme = "Dracula";
      pager = "ov -F H3";
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
  jq.enable = true;
  jqp.enable = true;
  tealdeer.enable = true;
  fzf.enable = true;
  fd.enable = true;
  starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = import ./starship-config.nix;
  };
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
  fastfetch = {
    enable = true;
    settings = import ./fastfetch-config.nix;
  };
  less.enable = true;
  topgrade = {
    # https://github.com/topgrade-rs/topgrade/blob/main/config.example.toml
    enable = true;
    settings = {
      misc.disable = [
        "nix"
        "chezmoi"
        "node"
        "pnpm"
        "bun"
        "github_cli_extensions"
        "uv"
        "poetry"
      ];
      commands = {
        "Upgrade Determinate Nix" = "sudo determinate-nixd upgrade";
        # TODO: Make this pure, not reference local filesystem.
        "Upgrade nix-darwin Flake " = "nix flake update --flake ~/.config/nix-darwin";
        "Rebuild nix-darwin Flake" =
          "sudo darwin-rebuild switch --flake ~/.config/nix-darwin --show-trace --impure";
      };
    };
  };

  # Terminal Multiplexers & Session Management
  zellij = {
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
  tmux.enable = true;

  # Development Tools
  git = {
    # Helpful ref: https://gist.github.com/pksunkara/988716
    enable = true;
    ignores = [
      "**/.DS_Store"
      "**/__pycache__/"
      "**/.ruff_cache/"
      "**/.mypy_cache/"
      "**/.env"
      "**/.venv"
      "*.com"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"
      "*.swp"
      "*.swo"
      "*~"
      "ehthumbs.db"
      "Icon?"
      "Thumbs.db"
    ];
    lfs.enable = true;
    settings = {
      # https://noborus.github.io/ov/delta/index.html
      # core = {
      #   pager = "delta --pager='ov -F'"; # set by programs.delta
      # };
      init = {
        defaultBranch = "main";
        # https://pre-commit.com/#automatically-enabling-pre-commit-on-repositories
        # TODO: Write the ~/.git-template dir using nix
        templateDir = "~/.git-template";
      };
      # pager = {
      #   diff = "delta --features ov-diff";
      #   log = "delta --features ov-log";
      #   show = "delta --pager='ov -F --header 3'";
      # };
      user = {
        email = "GatlenCulp@gmail.com";
        name = "GatlenCulp";
      };
    };
  };

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
  # Maybe with learning: https://youtu.be/w7i4amO_zaE
  # neovim = import ./vim.nix { inherit pkgs; };  # Replaced by nixvim
  # nixvim = import ./nixvim.nix { inherit pkgs inputs; };
  nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  neovide = {
    enable = true;
  };

  # Network & Security
  ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };

    extraConfig = ''
      Include ~/.ssh/align.ssh
      Include ~/.ssh/metr.ssh
      Include ~/.ssh/extra.ssh
    '';
  };

  go.enable = true;

  # grep.enable = true; #not available?
}
