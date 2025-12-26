{
  programs.eza = {

    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
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
