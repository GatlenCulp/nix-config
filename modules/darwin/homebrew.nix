let
  # Third-party (non-official) taps. Homebrew 6.0 (June 2026) added "tap trust":
  # formulae/casks/commands from non-official taps refuse to load until the tap
  # is explicitly trusted, otherwise `brew bundle` aborts activation. `brew bundle`
  # does NOT auto-trust even fully-qualified entries, so every tap here must be
  # trusted. We do that declaratively via `nix-homebrew.trust.taps` below (it runs
  # `brew trust --tap` during activation, before the bundle).
  taps = [
    "charmbracelet/tap"
    "mayowa-ojo/tap"
    "noborus/tap"
    "manaflow-ai/cmux" # cmux terminal
    "stablyai/orca" # orca agent IDE
    "infisical/get-cli" # infisical CLI
  ];
in
{
  # Trust the non-official taps this host declares. Note (per nix-homebrew): trust
  # entries are NOT removed when you drop a tap from this list — use `brew untrust`.
  nix-homebrew.trust.taps = taps;

  homebrew = {
    enable = true; # manage casks/brews/MAS apps so a factory-reset rebuild reinstalls everything

    onActivation = {
      autoUpdate = false; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = false; # Upgrade outdated casks, formulae, and App Store apps
      # 'none': never uninstall anything — keeps manually-installed brew packages.
      # (was 'zap', which would remove any formula/cask not declared here.)
      cleanup = "none";
    };

    inherit taps;

    brews = [
      "clipboard"
      "mayowa-ojo/tap/chmod-cli"
      "flit" # possibly https://search.nixos.org/packages?channel=25.05&query=flit
      "czg"
      "ucspi-tcp"
      "zrok"
      "hf" # HuggingFace CLI (formula renamed from huggingface-cli)
      "latexindent"
      "tiger-vnc" # VNC client; nixpkgs tigervnc is marked broken on darwin
      # Secret manager CLI. Official tap; chosen over nixpkgs (0.41.90) because
      # upstream is a self-updating vendor CLI shipping multiple releases/day
      # (0.43.x) — see .claude/skills/add-program-to-nix staleness rule.
      "infisical/get-cli/infisical"
    ];

    casks = [
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Development ━━━━━━━━━━━━━━━━━━━━━━━━━━━
      "netron" # On nixpkgs but not darwin
      "postman"
      "linear" # Linear desktop app (was manually installed, not in config)
      "gcloud-cli" # Google Cloud SDK (was manually installed, not in config)
      # "anythingllm" # Broken for some reason

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━ Browsers ━━━━━━━━━━━━━━━━━━━━━━━━━━
      "google-chrome"

      # ━━━━━━━━━━━━━━━━━━━━━━━━ Communication ━━━━━━━━━━━━━━━━━━━━━━━━
      "signal"
      "whatsapp"
      "discord" # Screenshare only works via brew.
      # ━━━━━━━━━━━━━━━━━━━━━━━━ Media & Creative ━━━━━━━━━━━━━━━━━━━━━━━━
      "adobe-creative-cloud"
      "clipgrab"
      "loom" # For contracting
      "obs"
      "vlc" # still installed despite MPV; kept per reset audit
      "canva" # still installed; kept per reset audit
      "cold-turkey-blocker"
      "jellyfin-media-player" # installed & used; nixpkgs jellyfin-media-player unavailable on darwin
      "sweet-home3d" # Interior design app (was manually installed, not in config)
      # "canva" # I don't use much anymore

      # ━━━━━━━━━━━━━━━━━━━━━━━ Productivity & Utilities ━━━━━━━━━━━━━━━━━━━━━━━
      # "applite" # I don't need this anymore for homebrew
      "flux-app"
      "bartender"
      "betterdisplay"
      "spotify" # For some reason, the nixpkgs version is breaking

      # ━━━━━━━━━━━━━━━━━━━━━━━━ Office & Knowledge ━━━━━━━━━━━━━━━━━━━━━━━━
      # "freedom" # Cold turkey better
      # "memory" # May return to
      "microsoft-auto-update"
      "microsoft-office"
      "notion"
      "notion-calendar"
      "notion-mail"
      "cleanshot"
      "notunes"
      "transmission" # Torrent
      "nordvpn"
      "tailscale-app"

      # ━━━━━━━━━━━━━━━━━━━━━━━ Security & Terminals ━━━━━━━━━━━━━━━━━━━━━━━
      # "burp-suite" # Don't need rn
      "1password" # Password manager desktop app (was manually installed, not in config)
      "ghostty"
      # "protonvpn" # I use NordVPN now
      # "qflipper" # Don't need rn
      "malwarebytes"

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Gaming ━━━━━━━━━━━━━━━━━━━━━━━━━━━
      "epic-games"
      "gog-galaxy"
      "minecraft"
      "steam"

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ AI ━━━━━━━━━━━━━━━━━━━━━━━━━━━
      "claude"
      "codex-app" # still installed; kept per reset audit
      # "chatgpt" Don't really use
      "openclaw"
      "manaflow-ai/cmux/cmux" # Ghostty-based terminal for parallel AI agents (config from home/ghostty)
      "stablyai/orca/orca" # Agent Development Environment (parallel agents across worktrees)

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Fonts ━━━━━━━━━━━━━━━━━━━━━━━━━━━
      "font-nova-round"

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ TeX ━━━━━━━━━━━━━━━━━━━━━━━━━━━
      "mactex"
    ];

    masApps = {
      "image2icon" = 992115977;
      # Xcode = 497799835; # Note: Takes almost an hour to download, skip for fast install
      # "1Password for Safari" = 1569813296;
    };
  };
}
