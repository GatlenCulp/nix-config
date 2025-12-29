{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [ pkgs.git ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version # Use packages
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/

  git-hooks.hooks = {
    nixfmt.enable = true;
  };

  # Temporarily disabled to fix rebuild after deleting pre-commit store paths
  # git-hooks.hooks = {
  #   # Format Nix code
  #   nixfmt.enable = true;
  #
  #   # Lint shell scripts
  #   shellcheck.enable = true;
  #
  #   # Execute shell examples in Markdown files
  #   mdsh.enable = true;
  #
  #   clippy.settings.allFeatures = true;
  #   # Define your own custom hooks
  # #   my-custom-hook = {
  # #     name = "My own hook";
  # #     exec = "on-pre-commit.sh";
  # #   };
  # # };
  #
  # # Use alternative pre-commit implementations
  # git-hooks.package = pkgs.prek;
  # };

  # tytanic = {
  # tytanic references apple_sdk.
  #   url = "github:typst-community/tytanic/v0.3.1";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };
}
