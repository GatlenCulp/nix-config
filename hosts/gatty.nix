{
  self,
  home-manager,
  nix-vscode-extensions,
  nur,
  nixvim,
  nvix,
  nix-homebrew,
  sops-nix,
  ...
}:
let
  secrets = import "/Users/gat/.config/nix-config/secrets/secrets.nix";
  homeManagerConfig = {
    imports = [
      sops-nix.homeManagerModules.sops

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

      "${self}/home/atuin"
      "${self}/home/claude-code"
      "${self}/home/cold-turkey"
      "${self}/home/desktoppr"
      "${self}/home/discord"
      "${self}/home/fastfetch"
      "${self}/home/firefox"
      "${self}/home/git"
      "${self}/home/ghostty"
      "${self}/home/helix"
      "${self}/home/jq"
      "${self}/home/less"
      "${self}/home/mise"
      "${self}/home/mpv"
      "${self}/home/neovide"
      "${self}/home/obsidian"
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

      "${self}/home/applications.nix"
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

    sops = {
      age.keyFile = "/Users/gat/.config/sops/age/keys-nix-sops.txt";
      defaultSopsFile = ../secrets/secrets.yaml;
      # config.sops.secrets.OPENAI_API_KEY.path points to a runtime-generated decrypted file. nix-darwin: Usually /run/secrets-for-users/<username>/OPENAI_API_KEY or similar
      secrets = {
        "OPENAI_API_KEY" = { };
        "ANTHROPIC_API_KEY" = { };
        "GEMINI_API_KEY" = { };
        "UV_PUBLISH_TOKEN" = { };
        "HUGGING_FACE_HUB_TOKEN" = { };
        "GATLEN_PERSONAL_RUNPOD_API_KEY" = { };
        "CSAIL_USERNAME" = { };

        # AWS
        "aws/credentials/default/aws_access_key_id" = { };
        "aws/credentials/default/aws_secret_access_key" = { };
        "aws/settings/default/region" = { };
        # "AWS_PROFILE" = { };
      };

    };
  };
in
{
  gatty-config =
    { pkgs, config, ... }:
    {
      imports = [
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        "${self}/home/aerospace"
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
