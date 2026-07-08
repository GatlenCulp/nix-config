{
  homebrew = {
    enable = false; # disable homebrew for fast deploy

    onActivation = {
      autoUpdate = false; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = false; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
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
      "huggingface-cli"
      "latexindent"
    ];

    casks = [
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Development ━━━━━━━━━━━━━━━━━━━━━━━━━━━
      "netron" # On nixpkgs but not darwin
      "postman"
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
      # "vlc" # use MPV
      "cold-turkey-blocker"
      # "jellyfin-media-player" #
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
      # "codex" DOn't really use
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
