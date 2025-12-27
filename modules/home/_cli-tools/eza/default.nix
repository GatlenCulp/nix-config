
{
  # A modern replacement for ‘ls’
  # useful in bash/zsh prompt, not in nushell.
  programs.eza = {

    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = false; # do not enable aliases in nushell!
    extraOptions = [
      "--width=100"
      "--group-directories-first"
      "--all"
    ];
    git = true;
    icons = "auto";
    theme = "dracula";
  };
}
