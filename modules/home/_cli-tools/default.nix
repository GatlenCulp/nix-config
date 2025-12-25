{ ... }:

let
  # Get all subdirectories containing default.nix files
  toolModules = map (dir: ./${dir}) [
    "aws-cli"
    "bat"
    "btop"
    "delta"
    "direnv"
    "emacs"
    "eza"
    "fd"
    "fzf"
    "gh"
    "jujutsu"
    "pandoc"
    "readline"
    "ripgrep"
    "tealdeer"
    "yazi"
    "zoxide"
  ];
in
{
  imports = toolModules;
}