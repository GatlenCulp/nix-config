{ pkgs, self, ... }:
{
  # Development Tools
  programs.git = {
    # Helpful ref: https://gist.github.com/pksunkara/988716
    enable = true;
    ignores = [
      "**/.DS_Store"
      "**/__pycache__/"
      "**/.ruff_cache/"
      "**/.mypy_cache/"
      "**/.env"
      "**/.venv"
      "*.com"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"
      "*.swp"
      "*.swo"
      "*~"
      "ehthumbs.db"
      "Icon?"
      "Thumbs.db"
    ];
    lfs.enable = true;
    settings = {
      # https://noborus.github.io/ov/delta/index.html
      # core = {
      #   pager = "delta --pager='ov -F'"; # set by programs.delta
      # };
      init = {
        defaultBranch = "main";
        # https://pre-commit.com/#automatically-enabling-pre-commit-on-repositories
        # TODO: Write the ~/.git-template dir using nix
        templateDir = "~/.git-template";
      };
      # pager = {
      #   diff = "delta --features ov-diff";
      #   log = "delta --features ov-log";
      #   show = "delta --pager='ov -F --header 3'";
      # };
      user = {
        email = "GatlenCulp@gmail.com";
        name = "GatlenCulp";
      };
    };
  };

}
