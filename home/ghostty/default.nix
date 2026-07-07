# Will fix later :(
# Anti home-manager stuff and other ways of linking files: https://ayats.org/blog/no-home-manager
#
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
  # home.file."./.config/ghostty/config" = {
  # Live-editable: symlink straight to the repo file (mkOutOfStoreSymlink) so
  # tweaks apply instantly with no rebuild and flow back to git. Replaces the
  # previous `mutable = true` copy, which was overwritten from the store on
  # every activation.
  xdg.configFile."ghostty/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/ghostty/config";
  };

  # home.file."./.config/ghostty/startup.sh" = {
  xdg.configFile."ghostty/startup.sh" = {
    source = ./startup.sh;
    executable = true;
  };

  # home.file."./.config/ghostty/test-file.txt" = {
  xdg.configFile."ghostty/test-file.txt" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/ghostty/test-file.txt";
  };

  #  Duplicate (macOS Application Support path) — symlink it too so both
  #  locations stay live-editable and in sync with the repo.
  home.file."./Library/Application Support/com.mitchellh.ghostty.config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/ghostty/config";
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
