{
  pkgs,
  secrets,
  lib,
  config,
  ...
}:
let
  sharedShellInitData = import ./shared-rc.nix {
    inherit pkgs secrets config;
  };
  sharedShellInit = sharedShellInitData.sharedShellInit;
  zshConfig = import ./zsh.nix;
  bashConfig = import ./bash.nix;
  fishConfig = import ./fish.nix;
  nushellConfig = import ./nushell.nix;
in
lib.mkMerge [
  zshConfig
  bashConfig
  fishConfig
  nushellConfig
  {
    # home.shellAliases = {};
    programs.zsh.initContent = sharedShellInit;
    programs.bash.initExtra = sharedShellInit;
  }
]
