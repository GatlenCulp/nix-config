{
  pkgs,
  config,
  self,
  ...
}:
let
  # kinda ugly, maybe fix later
  flakeDir = "${config.home.homeDirectory}/.config/nix-config";
in
{
  # Development Tools
  # rio stays disabled (parity with the prior config). Because the HM module
  # writes nothing while disabled, the symlink below needs no lib.mkForce.
  programs.rio.enable = false; # not needed rn

  # Live-editable: symlink straight to the repo file (mkOutOfStoreSymlink) so
  # tweaks apply instantly with no rebuild and flow back to git. The original
  # Nix source is preserved (unimported) in ./settings.legacy.nix; it is
  # rendered to ./config.toml, which this symlink targets.
  xdg.configFile."rio/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/rio/config.toml";
  };
}
