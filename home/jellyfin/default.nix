# https://wiki.nixos.org/wiki/Jellyfin
{ pkgs, ... }:
{
  home.packages = [
    # Client
    # pkgs.jellyfin-media-player # Not available on my system
    # Server
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # Server
  # services.jellyfin.enable = false; # False because not using frequently. Also not a home-manager option.
}