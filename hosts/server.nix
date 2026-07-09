{
  self,
  home-manager,
  # nix-vscode-extensions,
  # nur,
  nix-homebrew,
  sops-nix,
  nix-gat-vscode,
  ...
}@inputs:
let
  secrets = import "/Users/gat/.config/nix-config/secrets/secrets.nix";
  homeManagerConfig = {
    imports = [
      "${self}/home/mutability.nix" # Mutability Option Extension
      "${self}/home/vscode/vscode-mutability.nix" # Mutability Extension for VSCode

      ### FLAKE MODULES
      sops-nix.homeManagerModules.sops
      nix-gat-vscode.homeManagerModules.vscode

      ### PROGRAM GROUPINGS
      # "${self}/home/_accounts"
      "${self}/home/_cli-tools"
      # "${self}/home/_cloud"
      # "${self}/home/_encryption"
      # "${self}/home/_go"
      # "${self}/home/_java"
      # "${self}/home/_js"
      "${self}/home/_nix"
      "${self}/home/_python"
      # "${self}/home/_ruby"
      # "${self}/home/_rust"
      # "${self}/home/_sql"
      # "${self}/home/_tex"
      # "${self}/home/_typst"

      ### PROGRAMS
      "${self}/home/aerospace"
      "${self}/home/atuin"
      "${self}/home/claude-code"
      # "${self}/home/cold-turkey"
      "${self}/home/desktoppr"
      "${self}/home/discord"
      # "${self}/home/dropbox"
      "${self}/home/duti"
      "${self}/home/fastfetch"
      # "${self}/home/firefox" # re-enable nur packages, takes a while to build.
      "${self}/home/git"
      "${self}/home/ghostty"
      "${self}/home/helix"
      "${self}/home/jankyborders"
      "${self}/home/jellyfin"
      "${self}/home/jq"
      "${self}/home/less"
      "${self}/home/mise"
      "${self}/home/mpv"
      # "${self}/home/neovide"
      "${self}/home/nvim"
      # "${self}/home/obsidian"
      # "${self}/home/opencode"
      # "${self}/home/rectangle"
      # "${self}/home/rio"
      # "${self}/home/ruff"
      "${self}/home/shells"
      # "${self}/home/sketchybar"
      # "${self}/home/spotify"
      "${self}/home/ssh"
      "${self}/home/starship"
      # "${self}/home/thunderbird"
      "${self}/home/topgrade"
      "${self}/home/vscode"
      # "${self}/home/zed"
      "${self}/home/zellij"

      "${self}/secrets/sops.nix"
    ];

    home = {
      stateVersion = "25.05";
      enableNixpkgsReleaseCheck = false;
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
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "gat";
          };
        }
        "${self}/home/system-defaults.nix"
        "${self}/home/system-packages.nix"
        {
          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            primaryUser = "gat";
            stateVersion = 5; # Now at version 6
          };
        }
      ];
      nixpkgs = {
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
        hostPlatform.system = "aarch64-darwin";
        overlays = [
          # nix-vscode-extensions.overlays.default
          nix-gat-vscode.overlays.default
          # nur.overlays.default
          # (import "${self}/overlays/open-webui-fix.nix")
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
          # configureBuildUsers = false; # doesn't exist
          # auto-optimize-store = true; # Doesn't exist oop
        };
      };
      services.nix-daemon.enableSocketListener = true;

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

      # Not working. Freezes rebuild... or maybe not?? :/
      # launchd.daemons.nix-daemon = {
      #   serviceConfig = {
      #     Label = "org.nixos.nix-daemon";
      #     ProgramArguments = [
      #       "/nix/var/nix/profiles/default/bin/nix-daemon"
      #     ];
      #     RunAtLoad = true;
      #     KeepAlive = true;
      #   };
      # };

      homebrew = {
        enable = false; # disable homebrew for fast deploy

        onActivation = {
          autoUpdate = false; # Fetch the newest stable branch of Homebrew's git repo
          upgrade = false; # Upgrade outdated casks, formulae, and App Store apps
          # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
          cleanup = "zap";
        };

        casks = [
          "tailscale-app"
        ];
      };

      users.users.gat = {
        home = "/Users/gat";
        name = "gat";
        description = "Gatlen Culp";
        # Doesn't work?
        # shell = home-manager.pkgs.nushell;
        # shell = pkgs.nushell;
      };
      modules.desktop.fonts.enable = true;
      home-manager = {
        sharedModules = [ ];
        extraSpecialArgs = {
          inherit self;
          inherit secrets;
          inherit inputs;
        };
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
        users.gat = homeManagerConfig;
      };
    };
}
