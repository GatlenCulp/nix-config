# Atuin replaces your existing shell history with a SQLite database,
# and records additional context for your commands.
# Additionally, it provides optional and fully encrypted
# synchronisation of your history between machines, via an Atuin server.
{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
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
