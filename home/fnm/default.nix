{ pkgs, ... }:
{
  home.packages = [ pkgs.fnm ];

  programs.zsh.initContent = ''
    if command -v fnm >/dev/null 2>&1; then
      eval "$(fnm env --use-on-cd --shell zsh)"
    fi
  '';

  programs.bash.initExtra = ''
    if command -v fnm >/dev/null 2>&1; then
      eval "$(fnm env --use-on-cd --shell bash)"
    fi
  '';

  programs.fish.interactiveShellInit = ''
    if command -v fnm >/dev/null 2>&1
      fnm env --use-on-cd --shell fish | source
    end
  '';
}
