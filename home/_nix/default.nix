{ pkgs, ...}:
{
  home.packages = with pkgs; [
      # Language Servers
      nixd
      statix
      deadnix

      # Utils
      nixdoc
      nix-tree # A TUI to visualize the dependency graph of a nix derivation
      # it provides the command `nom` works just like `nix` with more details log output
      nix-output-monitor

      # Formatting
      nixfmt-rfc-style # Alejandra is an alternative, but this is fine tbh https://github.com/kamadorueda/alejandra
      cabal-install # haskell but needed for nixfmt sometimes
      nixfmt-tree # only for nix formatting recursively
      # treefmt # all-in-one formatter using a nix setup
  ];
  programs.nh.enable = true;
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };
}
