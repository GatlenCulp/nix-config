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
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    # Live-editable: the AeroSpace config is no longer generated from Nix.
    # The settings attrset now lives in `settings.legacy.nix` (unimported,
    # kept for reference / switch-back) and is rendered once into
    # `aerospace.toml`, which we symlink live below. Tweaks to that TOML
    # apply on `aerospace reload-config` with no rebuild and flow back to git.
  };

  # Home-manager's programs.aerospace module unconditionally writes
  # home.file.".config/aerospace/aerospace.toml" from the store when enable = true.
  # Override that exact home.file entry (NOT a separate xdg.configFile entry —
  # that resolves to the same target and trips home-manager's "conflicting managed
  # target files" assertion) with an out-of-store symlink to the committed repo
  # file so the config stays live-editable.
  home.file.".config/aerospace/aerospace.toml".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/aerospace/aerospace.toml"
  );

  # home.file.".config/aerospace/pip-move.sh" = {
  xdg.configFile."aerospace/pip-move.sh" = {
    source = ./pip-move.sh;
    executable = true;
  };
}

# [[on-window-detected]]
#     if.app-id = 'org.alacritty'
#     run = 'move-node-to-workspace T' # mnemonics T - Terminal
#
# [[on-window-detected]]
#     if.app-id = 'com.google.Chrome'
#     run = 'move-node-to-workspace W' # mnemonics W - Web browser
#
# [[on-window-detected]]
#     if.app-id = 'com.jetbrains.intellij'
#     run = 'move-node-to-workspace I' # mnemonics I - IDE
