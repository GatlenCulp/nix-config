# hosts/gatty.nix
#
# Personal laptop ("gatty"). This is the machine Gatlen does personal work on:
# the full app/tooling set, personal git identity, personal secrets, and the
# personal Homebrew casks. Everything shared with other machines lives in
# hosts/base.nix -- this file only declares the personal-specific bits.
inputs@{
  self,
  home-manager,
  nix-homebrew,
  sops-nix,
  nix-gat-vscode,
  ...
}:
let
  host = {
    username = "gat";
    homeDir = "/Users/gat";
    hostName = "gatty";
    flakeName = "gatty"; # darwinConfigurations.<name>; used by the `rebuild` alias
    profile = "personal";

    git = {
      name = "GatlenCulp";
      email = "GatlenCulp@gmail.com";
    };

    # Personal machine's own plaintext secrets (gitignored, exists locally).
    secretsPath = "/Users/gat/.config/nix-config/secrets/secrets.nix";

    # Personal sops-nix identity: personal age key decrypts secrets.yaml.
    sops = {
      sopsFile = self + "/secrets/secrets.yaml";
      ageKeyFile = "/Users/gat/.config/sops/age/keys-nix-sops.txt";
      symlinkPath = "/Users/gat/.config/sops-nix/secrets";
      mountPoint = "/Users/gat/.config/sops-nix/secrets.d";
    };

    # docker is pulled in transitively (devops tooling) and nixpkgs 25.11 flags
    # docker-28.5.2 as insecure. Permit it explicitly so eval succeeds.
    permittedInsecurePackages = [ "docker-28.5.2" ];

    extraOverlays = [ ];

    # System-level (darwin) modules unique to this host.
    darwinModules = [
      "${self}/modules/darwin/fonts.nix"
      "${self}/modules/darwin/homebrew.nix"
    ];

    # User-level (home-manager) modules. Personal = the full set.
    homeModules = [
      ### PROGRAM GROUPINGS
      "${self}/home/_accounts"
      "${self}/home/_cli-tools"
      "${self}/home/_cloud"
      "${self}/home/_encryption"
      "${self}/home/_go"
      "${self}/home/_java"
      "${self}/home/_js"
      "${self}/home/_nix"
      "${self}/home/_python"
      "${self}/home/_ruby"
      "${self}/home/_rust"
      "${self}/home/_sql"
      "${self}/home/_tex"
      "${self}/home/_typst"

      ### PROGRAMS
      "${self}/home/aerospace"
      "${self}/home/atuin"
      "${self}/home/claude-code"
      "${self}/home/cmux"
      "${self}/home/cold-turkey"
      "${self}/home/desktoppr"
      "${self}/home/discord"
      "${self}/home/dropbox"
      "${self}/home/duti"
      "${self}/home/fastfetch"
      # "${self}/home/firefox" # re-enable nur packages, takes a while to build.
      "${self}/home/git"
      "${self}/home/ghostty"
      "${self}/home/helix"
      "${self}/home/jankyborders"
      "${self}/home/jellyfin"
      "${self}/home/jq"
      "${self}/home/less"
      "${self}/home/mise"
      "${self}/home/mpv"
      "${self}/home/neovide"
      "${self}/home/nvim"
      "${self}/home/obsidian"
      "${self}/home/opencode"
      # "${self}/home/rectangle"
      "${self}/home/rio"
      "${self}/home/ruff"
      "${self}/home/shells"
      "${self}/home/sketchybar"
      "${self}/home/spotify"
      "${self}/home/ssh"
      "${self}/home/starship"
      "${self}/home/thunderbird"
      "${self}/home/topgrade"
      "${self}/home/vscode"
      "${self}/home/zed"
      "${self}/home/zellij"
    ];
  };
in
import ./base.nix (inputs // { inherit host; })
