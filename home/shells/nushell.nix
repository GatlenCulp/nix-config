# In part from https://wiki.nixos.org/wiki/Nushell
{ lib, pkgs, ... }:
{
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
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
