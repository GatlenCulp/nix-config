{
  programs.topgrade = {
    # https://github.com/topgrade-rs/topgrade/blob/main/config.example.toml
    enable = true;
    settings = {
      misc.disable = [
        # "nix"
        "chezmoi"
        "node"
        "pnpm"
        "bun"
        "github_cli_extensions"
        "uv"
        "poetry"
        "containers"
      ];
      # NOTE: these render to TOML as a nix attrset, so topgrade sees them in
      # ALPHABETICAL order, not the order written here. The numeric prefixes are
      # load-bearing -- without them "Rebuild nix-darwin" sorted ahead of
      # "Upgrade nix-config Flake", so every `upgrade` rebuilt the OLD lock and
      # only picked up the update on the following run.
      commands = {
        # "Upgrade Determinate Nix" = "sudo determinate-nixd upgrade"; # No longer needed, using lix
        # TODO: Make this pure, not reference local filesystem.

        # Re-pin uv to the newest upstream release before rebuilding, so a
        # `upgrade` always lands current uv instead of waiting on a nixpkgs bump.
        # Exits 0 with no changes when already current. See pkgs/uv/update.sh.
        "1. Re-pin uv" = "~/.config/nix-config/pkgs/uv/update.sh";
        "2. Upgrade nix-config Flake" = "nix flake update --flake ~/.config/nix-config";
        "3. Rebuild nix-darwin" =
          "sudo darwin-rebuild switch --flake ~/.config/nix-config --show-trace --impure";
      };
    };
  };
}
