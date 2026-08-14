{ pkgs, self, ... }:
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
  programs.uv = {
    enable = true;
    # Latest upstream uv, not the channel's. home-manager evaluates against
    # nix-darwin's pkgs (useGlobalPkgs), i.e. nixpkgs-25.11, which is frozen
    # many minor versions behind; even unstable trails releases by a day or
    # more. pkgs/uv is a sha256-pinned fetch of Astral's official binary,
    # re-pinned by pkgs/uv/update.sh (which `upgrade` runs) -- see the header
    # comment there.
    #
    # Deliberately set here rather than as a global `uv` overlay: other packages
    # (prek) take uv as a build input, and overriding it globally would knock
    # them off the binary cache and force a from-source rebuild.
    package = pkgs.callPackage "${self}/pkgs/uv" { };
  };
}
