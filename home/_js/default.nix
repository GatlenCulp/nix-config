{ pkgs, ...}:
{
  programs.bun = {
    enable = true;
    enableGitIntegration = true;
  };

  home.packages = [
    pkgs.fnm
  ];
}
