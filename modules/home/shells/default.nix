{ pkgs, secrets, ... }:
let
  sharedShellInitData = import ./shared-rc.nix {
    inherit pkgs;
    inherit secrets;
  };
  sharedShellInit = sharedShellInitData.sharedShellInit;
  zshConfig = import ./zsh.nix;
  bashConfig = import ./bash.nix;
  fishConfig = import ./fish.nix;
  nushellConfig = import ./nushell.nix;
in
zshConfig
// bashConfig
// fishConfig
// nushellConfig
// {
  programs.zsh.initExtra = sharedShellInit;
  programs.bash.initExtra = sharedShellInit;
}
