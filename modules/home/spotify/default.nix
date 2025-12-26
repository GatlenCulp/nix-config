{ secrets, ... }:
{
  programs.spotify-player = {
    enable = true;
  };

  # services.spotifyd = {
  #   enable = true;
  #   settings = {
  #     global = {
  #       username = "thegamemagnet";
  #       password = "${secrets.spotifyPassword}";
  #       device_name = "nix";
  #     };
  #   };
  # };
}
