{ inputs, ... }:

{
  git-hooks.hooks = {
    # Format Nix code
    nixfmt.enable = true;

    # Format Python code
    black.enable = true;

    # Lint shell scripts
    shellcheck.enable = true;

    # Execute shell examples in Markdown files
    mdsh.enable = true;

    # Override a package with a different version
    ormolu.enable = true;
    ormolu.package = pkgs.haskellPackages.ormolu;

    # Some hooks have more than one package, like clippy:
    clippy.enable = true;
    clippy.packageOverrides.cargo = pkgs.cargo;
    clippy.packageOverrides.clippy = pkgs.clippy;
    # Some hooks provide settings
    clippy.settings.allFeatures = true;

    # Define your own custom hooks
    my-custom-hook = {
      name = "My own hook";
      exec = "on-pre-commit.sh";
    };
  };

  # Use alternative pre-commit implementations
  git-hooks.package = pkgs.prek;
}
