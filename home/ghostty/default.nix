# Will fix later :()
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
  home.file."./.config/ghostty/config" = {
    source = ./config;
    mutable = true;
    force = true;
  };

  home.file."./.config/ghostty/startup.sh" = {
    source = ./startup.sh;
    executable = true;
  };

  home.file."./.config/ghostty/test-file.txt" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/ghostty/test-file.txt";

  };

  #  Duplicate
  home.file."./Library/Application Support/com.mitchellh.ghostty.config" = {
    source = ./config;
  };
  # programs.ghostty = {
  #   enable = true;
  #   package =
  #     if pkgs.stdenv.isDarwin then
  #       pkgs.hello # pkgs.ghostty is currently broken on darwing
  #     else
  #       pkgs.ghostty; # the stable version
  #   # package = ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default; # the latest version
  #   enableBashIntegration = false;
  #   installBatSyntax = false;
  #   # installVimSyntax = true;
  #   settings = {
  #     font-family = "Maple Mono NF CN";
  #     font-size = 13;

  #     background-opacity = 0.93;
  #     # only supported on macOS;
  #     background-blur-radius = 10;
  #     scrollback-limit = 20000;

  #     # https://ghostty.org/docs/config/reference#command
  #     #  To resolve issues:
  #     #    1. https://github.com/ryan4yin/nix-config/issues/26
  #     #    2. https://github.com/ryan4yin/nix-config/issues/8
  #     #  Spawn a nushell in login mode via `bash`
  #     command = "${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'";
  #   };
  # };
}
