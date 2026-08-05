{ pkgs, ... }:

let
  wallpaper = ../../assets/wallpaper-cyberpunk.jpg;
in
{
  programs.desktoppr = {
    enable = true;
    settings.picture = wallpaper;
  };

  # Fallback: `programs.desktoppr` sets the wallpaper via a home-manager
  # activation step, but darwin's activate script runs `brew bundle` (with
  # `set -e`) just ahead of it — a single broken cask aborts activation before
  # `desktoppr manage` fires and the wallpaper silently stops updating. This
  # launchd agent re-applies the wallpaper at every login using the store path
  # directly, so it works even when activation was skipped.
  launchd.agents.desktoppr = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.desktoppr}/bin/desktoppr"
        "${wallpaper}"
      ];
      RunAtLoad = true;
    };
  };
}
