{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      inline_height = 18;
      max_preview_height = 1;
      theme.name = "dracula";
    };
    themes.dracula = {
      theme.name = "Dracula";
      colors = {
        AlertError = "#FF6E6E";
        AlertInfo = "#D6ACFF";
        AlertWarn = "#FFFFA5";
        Annotation = "#6272A4";
        Base = "#F8F8F2";
        Guidance = "#50FA7B";
        Important = "#A4FFFF";
        Title = "#ABB2BF";
      };
    };
  };
}
