{ config, lib, ... }:
let
  # kinda ugly, maybe fix later
  flakeDir = "${config.home.homeDirectory}/.config/nix-config";
in
{
  # Keep the ruff program enabled (installs the package / integrations) but
  # stop Nix from generating ~/.config/ruff/ruff.toml. Instead symlink the
  # live config straight to the repo file via mkOutOfStoreSymlink, so edits
  # apply instantly with no rebuild and flow back to git.
  #
  # The full Nix source for these settings is preserved (unimported) in
  # ./settings.legacy.nix for reference / switch-back.
  programs.ruff = {
    enable = true;
  };

  xdg.configFile."ruff/ruff.toml" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/ruff/ruff.toml";
  };
}
