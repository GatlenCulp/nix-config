{
  description = "Gatlen's nix-darwin macOS nix configuration";

  inputs = {
    nixpkgs-stable-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs.follows = "nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # Recommends not using following
    };
    nvix = {
      url = "github:GatlenCulp/nvix";
      # url = "path:/Users/gat/personal/nvix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-vscode-extensions,
      nur,
      nixvim,
      nvix,
      nix-homebrew,
      # nix-rosetta-builder,
      ...
    }:
    let
      secrets = import "/Users/gat/.config/nix-config/secrets/secrets.nix";
      systemPackages = pkgs: import "${self}/modules/darwin/system-packages.nix" { inherit pkgs; };
      homebrewConfig = import "${self}/modules/darwin/homebrew.nix";
      systemDefaults = import "${self}/modules/darwin/system-defaults.nix";

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Home Manager Configuration ━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
      homeManagerConfig =
        { pkgs, ... }:
        {
          imports = [
            "${self}/modules/home/_accounts"
            "${self}/modules/home/_cli-tools"
            "${self}/modules/home/_go"
            "${self}/modules/home/_js"
            "${self}/modules/home/_nix"
            "${self}/modules/home/_python"
            "${self}/modules/home/_sql"
            "${self}/modules/home/_tex"

            "${self}/modules/home/atuin"
            "${self}/modules/home/claude-code"
            "${self}/modules/home/desktoppr"
            "${self}/modules/home/fastfetch"
            # "${self}/modules/home/firefox"
            "${self}/modules/home/git"
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

          home.stateVersion = "25.05";
          home.enableNixpkgsReleaseCheck = false; # So I can use old nixpkgs with new home-manager. Can't update nixpkgs bc then nix-darwin freaks.
          home.shellAliases = {
            config = "$EDITOR ~/.config/nix-config";
            rebuild = "sudo darwin-rebuild switch --flake ~/.config/nix-config --show-trace --impure";
            upgrade = "topgrade";
            lsr = "eza -T --git-ignore";
          };
          home.shell = {
            enableShellIntegration = true;
          };

          xdg = {
            enable = true;
            cacheHome = "/Users/gat/.cache";
            configHome = "/Users/gat/.config";
            dataHome = "/Users/gat/.local/share";
          };
        };

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Main Darwin Configuration ━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
      configuration =
        { pkgs, ... }:
        {
          # Core Setup
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
          ];
          # Not working atm. Fix later.
          nixpkgs.config.allowUnfree = true;
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.overlays = [
            nix-vscode-extensions.overlays.default
            nur.overlays.default
          ];

          # Environment
          environment = {
            darwinConfig = "$HOME/.config/nix-config";
            pathsToLink = [
              "/share/zsh"
              "/share/bash-completion"
            ];
            systemPackages = (systemPackages pkgs);
            systemPath = [
              "/Users/gat/.cargo/bin"
              "/Users/gat/.local/share/../bin"
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

          # System Configuration
          system = systemDefaults // {
            configurationRevision = self.rev or self.dirtyRev or null;
            primaryUser = "gat";
            stateVersion = 5;
          };

          # User Configuration
          users.users.gat = {
            home = "/Users/gat";
            name = "gat";
            # Doesn't work?
            # shell = home-manager.pkgs.nushell;
            # shell = pkgs.nushell;
          };

          # Fonts
          fonts.packages = import "${self}/modules/darwin/fonts.nix" { inherit pkgs; };

          # Programs
          programs.zsh.enable = true; # Required for home-manager zsh integration

          # Services
          programs.gnupg.agent.enable = true;
          services.spotifyd = {
            enable = true;
            settings = {
              global = {
                username = "thegamemagnet";
                password = "${secrets.spotifyPassword}";
                device_name = "nix";
              };

            };
          };
          # services.dropbox.enable = true; # Doesn't work? For dropbox cli it seems
          # services.syncthing.enable = true; # Doesn't work for some reason
          # services.ludusavi.enable = true; # Doesn't exist
          # services.flameshot.enable = false; # Doesn't exist
          # services.gpg-agent = {
          #   enable = true;
          #   enableZshIntegration = true;
          #   enableNushellIntegration = true;
          # };

          # Nix Configuration
          nix = {
            # Was false and pkgs.nix I believe
            enable = true; # Handled by Determinate Nix
            package = pkgs.lixPackageSets.stable.lix; # Not used, convert in the future
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

          # Let Home-manager Manage itself (doesn't work?)
          # programs.home-manager.enable = true;

          # Homebrew
          homebrew = homebrewConfig;

          # Home Manager
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
    in
    {
      darwinConfigurations."gatty" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          # An existing Linux builder is needed to initially bootstrap `nix-rosetta-builder`.
          # If one isn't already available: comment out the `nix-rosetta-builder` module below,
          # uncomment this `linux-builder` module, and run `darwin-rebuild switch`:
          # { nix.linux-builder.enable = true; }
          # Then: uncomment `nix-rosetta-builder`, remove `linux-builder`, and `darwin-rebuild switch`
          # a second time. Subsequently, `nix-rosetta-builder` can rebuild itself.
          #nix-rosetta-builder.darwinModules.default
          #{
          # see available options in module.nix's `options.nix-rosetta-builder`
          # nix-rosetta-builder.onDemand = true;
          # }
        ];
      };
    };
}
