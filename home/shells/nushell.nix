# In part from https://wiki.nixos.org/wiki/Nushell
{ lib, pkgs, ... }:
{
  home.packages = [
    pkgs.nufmt
  ];
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    # Only keep config that requires Nix interpolation here
    extraConfig = ''
      # fish completions https://www.nushell.sh/cookbook/external_completers.html#fish-completer
      # Note: This uses Nix interpolation for pkgs.fish path, so it must stay in extraConfig
      let fish_completer = {|spans|
        ${lib.getExe pkgs.fish} --command $'complete "--do-complete=($spans | str join " ")"'
        | $"value(char tab)description(char newline)" + $in
        | from tsv --flexible --no-infer
      }
    '';
    # shellAliases = {
    #   vi = "hx";
    #   vim = "hx";
    #   nano = "hx";
    # };
    # zsh -c "your zsh command here"
    shellAliases = {
      edit-config = "^($env.EDITOR) ~/.config/nix-config";
      rebuild = "with-env {NIXPKGS_ALLOW_UNFREE: '1'} { ^sudo darwin-rebuild switch --flake ~/.config/nix-config --show-trace --impure }";
      lsr = "^eza -T --git-ignore";
    };
    plugins = [
      pkgs.nushellPlugins.polars
    ];
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
