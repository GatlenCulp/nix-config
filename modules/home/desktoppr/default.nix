{ config, pkgs, ... }:

{
  # Copy wallpaper to home directory first
  home.file.".config/wallpapers/cyberpunk.jpg".source = ./wallpaper-cyberpunk.jpg;

  programs.desktoppr = {
    enable = true;
    settings = {
      # Reference the file in home directory instead of Nix store
      picture = "${config.home.homeDirectory}/.config/nix-config/assets/wallpaper-cyberpunk.jpg";
    };
  };

  # Previous approach - causes timing issue during activation
  # Below was kind of breaking??
  # # Install desktoppr but don't use the built-in activation
  # home.packages = [ pkgs.desktoppr ];

  # # Use custom activation script that runs after files are linked
  # home.activation.setWallpaper = config.lib.dag.entryAfter ["writeBoundary"] ''
  #   wallpaper_path="${config.home.homeDirectory}/.config/wallpapers/cyberpunk.jpg"
  #   if [ -f "$wallpaper_path" ]; then
  #     $DRY_RUN_CMD ${pkgs.desktoppr}/bin/desktoppr "$wallpaper_path" || true
  #   fi
  # '';
}
