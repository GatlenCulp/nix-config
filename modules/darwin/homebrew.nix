{
  homebrew = {
    enable = true; # manage casks/brews/MAS apps so a factory-reset rebuild reinstalls everything

    onActivation = {
      autoUpdate = false; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = false; # Upgrade outdated casks, formulae, and App Store apps
      # 'none': never uninstall anything — keeps manually-installed brew packages.
      # (was 'zap', which would remove any formula/cask not declared here.)
      cleanup = "none";
    };

    taps = [
      "charmbracelet/tap"
      "mayowa-ojo/tap"
      "noborus/tap"
      "manaflow-ai/cmux" # cmux terminal
      "stablyai/orca" # orca agent IDE
    ];

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
