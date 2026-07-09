# hosts/work.nix
#
# Work laptop. Same declarative base as the personal machine (hosts/base.nix)
# but with a work-only surface: work git identity, work-only secrets, a curated
# tooling set (personal/social/media apps stripped), and an MDM-safe Homebrew
# config that never `zap`s corp-managed apps.
#
# ┌─────────────────────────────────────────────────────────────────────────┐
# │ TODO(work-provisioning): fill these in once the work laptop exists.       │
# │   1. `username` / `homeDir` — set to the corp-mandated account. Every      │
# │      path below is derived from `username`, so this is the only edit       │
# │      needed to re-home the whole config.                                    │
# │   2. `flakeName` — either rename this to the machine's real hostname (so    │
# │      `darwin-rebuild` auto-selects it) or keep "work" and rebuild with      │
# │      `--flake ~/.config/nix-config#work`.                                    │
# │   3. `git.email` — swap to the real work address when issued.              │
# │   4. Work secrets — create secrets/work-secrets.{nix,yaml}, add the work    │
# │      machine's age key to .sops.yaml, then point `sops.sopsFile` at the     │
# │      work file so this machine can NOT decrypt personal secrets.            │
# └─────────────────────────────────────────────────────────────────────────┘
inputs@{
  self,
  home-manager,
  nix-homebrew,
  sops-nix,
  nix-gat-vscode,
  ...
}:
let
  # TODO(work-provisioning): replace with the corp-mandated username.
  username = "gat";
  homeDir = "/Users/${username}";

  host = {
    inherit username homeDir;
    hostName = "work";
    flakeName = "work"; # rebuild with `--flake ~/.config/nix-config#work`
    profile = "work";

    git = {
      name = "GatlenCulp";
      # TODO(work-provisioning): swap to the real work email once issued.
      email = "GatlenCulp@gmail.com";
    };

    # Work-only plaintext secrets. Kept on a separate path so personal keys are
    # never present on the work disk. Guarded in base.nix -> evaluates to {} until
    # this file exists, so the profile builds today with nothing provisioned.
    secretsPath = "${homeDir}/.config/nix-config/secrets/work-secrets.nix";

    # TODO(work-provisioning): repoint sopsFile at secrets/work-secrets.yaml
    # (encrypted to the work machine's own age key) so this host cannot decrypt
    # personal secrets. Until then it reuses the shared file so the shell module,
    # which reads config.sops.secrets.*, still evaluates.
    sops = {
      sopsFile = self + "/secrets/secrets.yaml";
      ageKeyFile = "${homeDir}/.config/sops/age/keys-nix-sops.txt";
      symlinkPath = "${homeDir}/.config/sops-nix/secrets";
      mountPoint = "${homeDir}/.config/sops-nix/secrets.d";
    };

    permittedInsecurePackages = [ "docker-28.5.2" ];

    extraOverlays = [ ];

    darwinModules = [
      "${self}/modules/darwin/fonts.nix"
      "${self}/modules/darwin/homebrew-work.nix"
    ];

    # Curated for work: dev language/tooling groups kept; personal media, social,
    # and account modules dropped. Toggle lines to taste as work needs evolve.
    homeModules = [
      ### PROGRAM GROUPINGS (dev tooling — kept)
      # "${self}/home/_accounts"   # personal email/calendar accounts — off on work
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
      # "${self}/home/cold-turkey" # personal distraction blocker
      "${self}/home/desktoppr"
      # "${self}/home/discord"     # social — off on work
      # "${self}/home/dropbox"     # personal cloud — off on work
      "${self}/home/duti"
      "${self}/home/fastfetch"
      "${self}/home/git"
      "${self}/home/ghostty"
      "${self}/home/helix"
      "${self}/home/jankyborders"
      # "${self}/home/jellyfin"    # personal media server — off on work
      "${self}/home/jq"
      "${self}/home/less"
      "${self}/home/mise"
      # "${self}/home/mpv"         # media player — off on work
      "${self}/home/neovide"
      "${self}/home/nvim"
      # "${self}/home/obsidian"    # personal notes — off on work
      "${self}/home/opencode"
      "${self}/home/rio"
      "${self}/home/ruff"
      "${self}/home/shells"
      # "${self}/home/sketchybar"  # personal menu bar widgets
      # "${self}/home/spotify"     # personal media — off on work
      "${self}/home/ssh"
      "${self}/home/starship"
      # "${self}/home/thunderbird" # personal email — off on work
      "${self}/home/topgrade"
      "${self}/home/vscode"
      "${self}/home/zed"
      "${self}/home/zellij"
    ];
  };
in
import ./base.nix (inputs // { inherit host; })
