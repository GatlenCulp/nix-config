# hosts/base.nix
#
# Shared machine base. Everything that used to be copy-pasted between
# hosts/gatty.nix and hosts/server.nix lives here exactly once. Each host
# (hosts/gatty.nix, hosts/work.nix, ...) builds a small `host` spec and imports
# this module; the host only declares what makes it different.
#
# The `host` attrset is the single source of per-machine truth:
#   username / homeDir / hostName   -> who the machine belongs to (parameterized
#                                       so a work laptop with a corp-mandated
#                                       username needs no edits here)
#   flakeName                        -> the darwinConfigurations.<name> attr, used
#                                       by the `rebuild` alias to target this host
#   profile                          -> "personal" | "work" (free for modules to branch on)
#   git                             -> per-host commit identity
#   secretsPath                      -> plaintext secrets.nix for THIS machine only
#                                       (guarded: missing file -> {}), so work keys
#                                       never live on personal and vice versa
#   sops                             -> per-host sops-nix paths / encrypted file
#   permittedInsecurePackages        -> host-specific nixpkgs escape hatches
#   homeModules                      -> the home/* modules this host enables
#   darwinModules                    -> extra darwin modules (fonts, homebrew, ...)
{
  self,
  home-manager,
  nix-homebrew,
  sops-nix,
  nix-gat-vscode,
  host,
  ...
}@inputs:
let
  # nixvim/nvix retired: neovim is now a plain lazy.nvim config in home/nvim
  # (enabled per-host via host.homeModules), so there is no nixvim sharedModule.

  # Per-machine plaintext secrets. Guarded so a machine that has not been
  # provisioned yet (e.g. the work laptop before its secrets file exists)
  # still evaluates cleanly instead of erroring on a missing import.
  secrets =
    if builtins.pathExists host.secretsPath then import host.secretsPath else { };

  homeManagerConfig = {
    imports = [
      "${self}/home/mutability.nix" # Mutability Option Extension
      "${self}/home/vscode/vscode-mutability.nix" # Mutability Extension for VSCode

      ### FLAKE MODULES
      sops-nix.homeManagerModules.sops
      nix-gat-vscode.homeManagerModules.vscode

      ### SECRETS (reads host.sops)
      "${self}/secrets/sops.nix"
    ]
    ++ host.homeModules;

    home = {
      stateVersion = "25.05";
      enableNixpkgsReleaseCheck = false;
    };

    xdg.enable = true;
  };
in
{ pkgs, config, ... }:
{
  imports = [
    home-manager.darwinModules.home-manager
    nix-homebrew.darwinModules.nix-homebrew
    sops-nix.darwinModules.sops
    {
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = host.username;
      };
    }
    "${self}/home/system-defaults.nix"
    "${self}/home/system-packages.nix"
    {
      system = {
        configurationRevision = self.rev or self.dirtyRev or null;
        primaryUser = host.username;
        stateVersion = 5; # Now at version 6
      };
    }
  ]
  ++ host.darwinModules;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = host.permittedInsecurePackages;
    };
    hostPlatform.system = "aarch64-darwin";
    overlays = [
      nix-gat-vscode.overlays.default
      # Fix direnv 2.37.1 test failures and mpv version check
      (final: prev: {
        direnv = prev.direnv.overrideAttrs (oldAttrs: {
          doCheck = false;
        });
        mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (oldAttrs: {
          doInstallCheck = false;
        });
      })
    ]
    ++ host.extraOverlays;
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
        host.username
      ];
    };
  };
  services.nix-daemon.enableSocketListener = true;

  environment = {
    pathsToLink = [
      "/share/zsh"
      "/share/bash-completion"
    ];
    systemPath = [
      "${config.users.users.${host.username}.home}/.cargo/bin"
      "${config.users.users.${host.username}.home}/.local/bin"
    ];
  };

  users.users.${host.username} = {
    home = host.homeDir;
    name = host.username;
    description = "Gatlen Culp";
  };
  modules.desktop.fonts.enable = true;

  home-manager = {
    sharedModules = [ ];
    extraSpecialArgs = {
      inherit self secrets inputs host;
    };
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${host.username} = homeManagerConfig;
  };
}
