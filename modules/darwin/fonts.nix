{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    fonts.enable = lib.mkEnableOption "Rich Fonts - Add NerdFonts Icons, emojis & CJK Fonts";
  };

  config.fonts.packages =
    with pkgs;
    lib.mkIf cfg.fonts.enable [
      # icon fonts
      material-design-icons
      font-awesome

      # Nerd Fonts
      nerd-fonts.symbols-only # symbols icon only
      nerd-fonts.iosevka
      # fira-code
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
      nerd-fonts.monaspace
      julia-mono

      # Math Fonts
      # fira-math
      dejavu_fonts
      newcomputermodern
      lato
      libertinus
      stix-two
      xits-math
      texlivePackages.asana-math
      texlivePackages.gfsneohellenicmath
      texlivePackages.lete-sans-math
      texlivePackages.lm-math
      texlivePackages.tex-gyre
      texlivePackages.tex-gyre-math
      texlivePackages.termes-otf
      texlivePackages.sansmathfonts
      texlivePackages.notomath

      # Display
      blackout
      font-awesome

      noto-fonts
      noto-fonts-color-emoji
    ];
}
