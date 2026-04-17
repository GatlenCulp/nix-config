# https://wiki.nixos.org/wiki/Jellyfin
# Nix version of Jellyfin -- https://kiriwalawren.github.io/nixflix/
{ pkgs, ... }:
{
  
  home.packages = [
    # Client
    # pkgs.jellyfin-media-player # Not available on my system
    # Server
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
    pkgs.caddy
  ];

  # Server
  # services.jellyfin.enable = false; # False because not using frequently. Also not a home-manager option.
}