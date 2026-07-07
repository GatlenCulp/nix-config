{
  config,
  lib,
  ...
}:
let
  # kinda ugly, maybe fix later
  flakeDir = "${config.home.homeDirectory}/.config/nix-config";
in
{
  programs.fastfetch = {
    enable = true;
  };

  # Live-editable: symlink straight to the repo file (mkOutOfStoreSymlink) so
  # tweaks apply instantly with no rebuild and flow back to git. The Nix source
  # is preserved (unimported) in ./settings.legacy.nix and rendered once into
  # ./config.jsonc. `lib.mkForce` overrides the copy the programs.fastfetch
  # module would otherwise write from the store on every activation.
  xdg.configFile."fastfetch/config.jsonc" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/fastfetch/config.jsonc";
  };
}
