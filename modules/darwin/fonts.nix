{ pkgs }:
with pkgs;
[
  # Developer Fonts
  # fira-code
  nerd-fonts.fira-code
  nerd-fonts.hack
  nerd-fonts.jetbrains-mono
  nerd-fonts.noto
  nerd-fonts.monaspace
  julia-mono

  # Math Fonts
  dejavu_fonts
  # fira-math
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

  # TODO: Find material icons nerd font for eza and such.

  # Display
  blackout
  font-awesome
]
