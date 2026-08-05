{ config, lib, pkgs, ... }:

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

  # nix-darwin's activate script has `set -e` and runs `brew bundle` directly
  # ahead of the home-manager activation step. A single broken cask (recent
  # example: `betterdisplay`'s `command_wrapper` breakage in Homebrew 6.0) or
  # the `mas get` upstream regression causes brew bundle to exit non-zero,
  # which aborts activation *before* home-manager runs — silently killing
  # wallpaper, aerospace launchd agents, dotfile linking, everything.
  #
  # Override nix-darwin's homebrew activation to swallow the exit code and
  # continue. The failure is still printed to stderr, so genuine misconfigs
  # remain visible in rebuild output.
  system.activationScripts.homebrew.text = lib.mkForce ''
    echo >&2 "Homebrew bundle..."
    if [ -f "${config.homebrew.brewPrefix}/brew" ]; then
      PATH="${config.homebrew.brewPrefix}:${lib.makeBinPath [ pkgs.mas ]}:$PATH" \
      sudo \
        --preserve-env=PATH \
        --user=${lib.escapeShellArg config.homebrew.user} \
        --set-home \
        env \
        ${config.homebrew.onActivation.brewBundleCmd} \
        || printf >&2 '\e[1;33mwarning: brew bundle exited non-zero; continuing activation\e[0m\n'
    else
      echo -e "\e[1;31merror: Homebrew is not installed, skipping...\e[0m" >&2
    fi
  '';

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
      # "obs"
      # "vlc" # still installed despite MPV; kept per reset audit
      "canva" # still installed; kept per reset audit
      "cold-turkey-blocker"
      "jellyfin-media-player" # installed & used; nixpkgs jellyfin-media-player unavailable on darwin
      "sweet-home3d" # Interior design app (was manually installed, not in config)
      # "canva" # I don't use much anymore

      # ━━━━━━━━━━━━━━━━━━━━━━━ Productivity & Utilities ━━━━━━━━━━━━━━━━━━━━━━━
      # "applite" # I don't need this anymore for homebrew
      "flux-app"
      "bartender"
      # "betterdisplay" The actual cask is broken I think
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

    # ━━━━━━━━━━━━━━━━━━━━━━━━ Mac App Store ━━━━━━━━━━━━━━━━━━━━━━━━
    # TEMPORARILY DISABLED for two independent reasons:
    #   1. Upstream bug: `brew bundle` now calls `mas get <id>` (Homebrew/brew
    #      #21559), but the installed `mas` doesn't know `get` ("2 unexpected
    #      arguments: 'get', ...") — tracked in nix-darwin/nix-darwin#1722.
    #   2. `mas` can't download without being signed in to the App Store
    #      (fails with "MASError error 5").
    #
    # These no longer take down the rest of activation — the
    # `system.activationScripts.homebrew.text` override above makes brew bundle
    # non-fatal — but they still can't install in this state, so leave disabled.
    #
    # To re-enable: sign in to the App Store, confirm `mas` supports `get`
    # (`mas get <id>` works), then restore the block below and rebuild.
    masApps = {
      # "image2icon" = 992115977;
      # "Amphetamine" = 937984704; # Prevents sleep
      # "Command X" = 6448461551; # Adds cut/paste to Finder (Sindre Sorhus)
      # "Folder Preview" = 6698876601; # Quick Look for folder contents (Anybox)
      # "LastPass for Safari" = 6504626762; # Safari extension for LastPass
      # "Markdown Preview" = 6739955340; # Quick Look for Markdown (Anybox)
      # "Unzip - RAR ZIP 7Z Unarchiver" = 1537056818; # Archive extractor
      # Xcode = 497799835; # Note: Takes almost an hour to download, skip for fast install
    };
  };
}
