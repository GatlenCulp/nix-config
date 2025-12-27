{
  self,
  home-manager,
  nix-vscode-extensions,
  nur,
  nixvim,
  nvix,
  nix-homebrew,
  ...
}:
let
  secrets = import "/Users/gat/.config/nix-config/secrets/secrets.nix";
  homeManagerConfig = {
    imports = [
      "${self}/modules/home/_accounts"
      "${self}/modules/home/_cli-tools"
      "${self}/modules/home/_cloud"
      "${self}/modules/home/_encryption"
      "${self}/modules/home/_go"
      "${self}/modules/home/_js"
      "${self}/modules/home/_nix"
      "${self}/modules/home/_python"
      "${self}/modules/home/_sql"
      "${self}/modules/home/_tex"

      "${self}/modules/home/atuin"
      "${self}/modules/home/claude-code"
      "${self}/modules/home/desktoppr"
      "${self}/modules/home/discord"
      "${self}/modules/home/fastfetch"
      # "${self}/modules/home/firefox"
      "${self}/modules/home/git"
      "${self}/modules/home/ghostty"
      "${self}/modules/home/helix"
      "${self}/modules/home/jq"
      "${self}/modules/home/less"
      "${self}/modules/home/mise"
      "${self}/modules/home/mpv"
      "${self}/modules/home/neovide"
      "${self}/modules/home/obsidian"
      "${self}/modules/home/rio"
      "${self}/modules/home/ruff"
      "${self}/modules/home/shells"
      "${self}/modules/home/sketchybar"
      "${self}/modules/home/spotify"
      "${self}/modules/home/ssh"
      "${self}/modules/home/starship"
      "${self}/modules/home/thunderbird"
      "${self}/modules/home/topgrade"
      "${self}/modules/home/vscode"
      "${self}/modules/home/zed"
      "${self}/modules/home/zellij"

      "${self}/modules/home/applications.nix"
    ];

    home = {
      stateVersion = "25.05";
      enableNixpkgsReleaseCheck = false;
      shellAliases = {
        config = "$EDITOR ~/.config/nix-config";
        rebuild = "sudo darwin-rebuild switch --flake ~/.config/nix-config --show-trace --impure";
        upgrade = "topgrade";
        lsr = "eza -T --git-ignore";
      };
    };

    xdg.enable = true;
  };
in
{
  gatty-config =
    { pkgs, config, ... }:
    {
      imports = [
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        "${self}/modules/darwin/aerospace"
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "gat";
          };
        }
        # "${self}/modules/darwin/system-defaults.nix"
        # "${self}/modules/darwin/system-packages.nix"
        {
          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            primaryUser = "gat";
            stateVersion = 5; # Now at version 6
          };
        }
      ];
      nixpkgs = {
        config.allowUnfree = true; # Not working atm. Fix later.
        hostPlatform.system = "aarch64-darwin";
        overlays = [
          nix-vscode-extensions.overlays.default
          nur.overlays.default
        ];
      };
      nix = {
        enable = true;
        package = pkgs.lixPackageSets.stable.lix;
        settings = {
          "extra-experimental-features" = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "gat"
          ];
        };
      };

      environment = {
        pathsToLink = [
          "/share/zsh"
          "/share/bash-completion"
        ];
        systemPath = [
          "${config.users.users.gat.home}/.cargo/bin"
          "${config.users.users.gat.home}/.local/bin"
        ];
      };

      # launchd
      # launchd.user.agents = {
      #   zed-test = {
      #     command = "${pkgs.zed}/bin/zed";
      #     serviceConfig = {
      #       KeepAlive = false;
      #       RunAtLoad = true;
      #     };
      #   };
      # };

      users.users.gat = {
        home = "/Users/gat";
        name = "gat";
        description = "Gatlen Culp";
        # Doesn't work?
        # shell = home-manager.pkgs.nushell;
        # shell = pkgs.nushell;
      };
      modules.desktop.fonts.enable = true;
      homebrew = import "${self}/modules/darwin/homebrew.nix";
      home-manager = {
        sharedModules = [
          nixvim.homeModules.nixvim
          {
            programs.nixvim = {
              enable = true;
              viAlias = true;
              vimAlias = true;
              imports = with nvix.nvixPlugins; [
                ai
                common
                lang
                lsp
                lualine
                snacks
                autosession
                blink-cmp
                buffer
                firenvim
                git
                noice
                precognition
                smear-cursor
                tex
                treesitter
                ux
              ];
            };
          }
        ];
        extraSpecialArgs = {
          inherit self;
          inherit secrets;
        };
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
        users.gat = homeManagerConfig;
      };
    };
}
