# cmux — open-source Ghostty-based macOS terminal for running AI coding agents
# in parallel (https://github.com/manaflow-ai/cmux). Installed as a Homebrew
# cask (see modules/darwin/homebrew.nix); it is not in nixpkgs and has no
# home-manager module.
#
# cmux DERIVES its terminal appearance — theme, fonts, colors, keybindings —
# from the Ghostty config: on launch it reads ~/.config/ghostty/config, which
# this repo already symlinks to home/ghostty/config (see home/ghostty). So the
# terminal side of cmux *is* the ghostty config; there is nothing to duplicate.
#
# cmux's own app settings (vertical tabs, notifications, shortcuts, sidebar,
# browser) live in ~/.config/cmux/cmux.json. That file is symlinked to the repo
# below so it stays live-editable (no rebuild) and version-controlled — the same
# mkOutOfStoreSymlink pattern used for the other editable configs here.
{ config, ... }:
let
  flakeDir = "${config.home.homeDirectory}/.config/nix-config";
in
{
  # App-level settings, live-editable. cmux rewrites this file at runtime, so
  # once the symlink is in place its writes flow straight back into the repo
  # file; `force = true` only lets the symlink win over a file cmux may have
  # created before the first activation.
  xdg.configFile."cmux/cmux.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/cmux/cmux.json";
    force = true;
  };
}
