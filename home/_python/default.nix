{pkgs, ...}:
{
  home.packages = with pkgs;[
      cookiecutter
      cruft
      # nbqa  # Temporarily disabled - has broken pre-commit-hooks dependency
      pyright
      python3 # TODO: Perhaps replace with uv
      # pylint
      # validate-pyproject
    ];
  programs.poetry.enable = true;
  programs.uv.enable = true;
}
