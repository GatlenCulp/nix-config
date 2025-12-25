#Initial installation: sudo nix run nix-darwin -- switch --flake ~/.config/nix-config
# Subsequent updates: darwin-rebuild switch --flake ~/.config/nix-config
#
# nix-darwin: https://nix-darwin.github.io/nix-darwin/manual/index.html
# home-manager: https://nix-community.github.io/home-manager/options.xhtml
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
    # tytanic = {
    # tytanic references apple_sdk.
    #   url = "github:typst-community/tytanic/v0.3.1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # TODO: Global nix-colors, which is fine but they only have Base16 standard. Will define my own for now.
    # nix-colors= {url = "github:misterio77/nix-colors"};
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
      # tytanic,
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
      terminalPrograms =
        pkgs:
        import "${self}/modules/home/terminal/terminal-programs.nix" {
          inherit pkgs inputs secrets;
        };
      accountsConfig = import "${self}/modules/home/accounts.nix";
      customSystemPackages =
        { inputs, pkgs }:
        import "${self}/modules/darwin/custom-system-packages.nix" {
          inherit inputs pkgs;
        };

      shellConfig =
        pkgs:
        import "${self}/modules/home/terminal/shell-config.nix" {
          inherit pkgs secrets;
        };

      applicationPrograms = pkgs: import "${self}/modules/home/applications.nix" { inherit pkgs; };

      ruffSettings = import "${self}/modules/home/ruff.nix";
      sketchybarSettings = import "${self}/modules/home/sketchybar.nix";

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Home Manager Configuration ━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
      homeManagerConfig =
        { pkgs, ... }:
        {
          imports = [
            "${self}/modules/home/vscode"
            "${self}/modules/home/firefox"
            "${self}/modules/home/aerospace"
          ];

          home.stateVersion = "25.05";
          home.enableNixpkgsReleaseCheck = false; # So I can use old nixpkgs with new home-manager. Can't update nixpkgs bc then nix-darwin freaks.
          home.shellAliases = {
            config = "$EDITOR ~/.config/nix-config";
            rebuild = "sudo darwin-rebuild switch --flake ~/.config/nix-config --show-trace --impure";
            upgrade = "topgrade";
            lsr = "eza -T --git-ignore"; # List repo with ezaf
          };
          home.shell = {
            enableShellIntegration = true;
          };

          accounts = accountsConfig;

          xdg = {
            enable = true;
            cacheHome = "/Users/gat/.cache";
            configHome = "/Users/gat/.config";
            dataHome = "/Users/gat/.local/share";
          };

          programs =
            terminalPrograms pkgs
            // shellConfig pkgs
            // applicationPrograms pkgs
            // {
              ruff = {
                enable = true;
                settings = ruffSettings;
              };
            }
            // {
              sketchybar = {
                enable = false;
                config = sketchybarSettings;
                service.enable = true;
              };
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
            systemPackages = (systemPackages pkgs) ++ (customSystemPackages { inherit inputs pkgs; });
            systemPath = [
              "/Users/gat/.cargo/bin"
              "/Users/gat/.local/share/../bin"
            ];
          };

          # launchd
          launchd.user.agents = {
            zed-test = {
              command = "${pkgs.zed}/bin/zed";
              serviceConfig = {
                KeepAlive = false;
                RunAtLoad = true;
              };
            };
          };

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

          # Services
          # services.aerospace = {
          #   enable = true;
          #   settings = import "${self}/modules/home/aerospace-config.nix";
          # };
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
                programs.nixvim.imports = with nvix.nvixPlugins; [
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
              }
            ];
            extraSpecialArgs = {
              inherit self;
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
