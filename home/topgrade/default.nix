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
      commands = {
        # "Upgrade Determinate Nix" = "sudo determinate-nixd upgrade"; # No longer needed, using lix
        # TODO: Make this pure, not reference local filesystem.
        "Upgrade nix-config Flake " = "nix flake update --flake ~/.config/nix-config";
        "Rebuild nix-darwin" =
          "sudo darwin-rebuild switch --flake ~/.config/nix-config --show-trace --impure";
      };
    };
  };
}
