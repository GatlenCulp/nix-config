{
  self,
  home-manager,
  # nix-vscode-extensions,
  # nur,
  nixvim,
  nvix,
  nix-homebrew,
  sops-nix,
  nix-gat-vscode,
  ...
}@inputs:
let
  nixvim-config = {
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
  };
  secrets = import "/Users/gat/.config/nix-config/secrets/secrets.nix";
  homeManagerConfig = {
    imports = [
      ### FLAKE MODULES
      sops-nix.homeManagerModules.sops
      nix-gat-vscode.homeManagerModules.vscode

      ### PROGRAM GROUPINGS
      "${self}/home/_accounts"
      "${self}/home/_cli-tools"
      "${self}/home/_cloud"
      "${self}/home/_encryption"
      "${self}/home/_go"
      "${self}/home/_js"
      "${self}/home/_nix"
      "${self}/home/_python"
      "${self}/home/_sql"
      "${self}/home/_tex"

      ### PROGRAMS
      "${self}/home/aerospace"
      "${self}/home/atuin"
      "${self}/home/claude-code"
      "${self}/home/cold-turkey"
      "${self}/home/desktoppr"
      "${self}/home/discord"
      "${self}/home/dropbox"
      "${self}/home/fastfetch"
      # "${self}/home/firefox" # re-enable nur packages, takes a while to build.
      "${self}/home/git"
      "${self}/home/ghostty"
      "${self}/home/helix"
      "${self}/home/jankyborders"
      "${self}/home/jq"
      "${self}/home/less"
      "${self}/home/mise"
      "${self}/home/mpv"
      "${self}/home/neovide"
      "${self}/home/obsidian"
      "${self}/home/opencode"
      "${self}/home/rio"
      "${self}/home/ruff"
      "${self}/home/shells"
      "${self}/home/sketchybar"
      "${self}/home/spotify"
      "${self}/home/ssh"
      "${self}/home/starship"
      "${self}/home/thunderbird"
      "${self}/home/topgrade"
      "${self}/home/vscode"
      "${self}/home/zed"
      "${self}/home/zellij"

      "${self}/secrets/sops.nix"

      "${self}/home/mutability.nix" # Mutability Option Extension
      "${self}/home/vscode/vscode-mutability.nix" # Mutability Extension for VSCode
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
        sharedModules = [
          nixvim.homeModules.nixvim
          nixvim-config
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
