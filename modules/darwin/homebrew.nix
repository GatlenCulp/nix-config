{
  enable = true;
  taps = [
    "charmbracelet/tap"
    "mayowa-ojo/tap"
    "noborus/tap"
  ];

  brews = [
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Core CLI ━━━━━━━━━━━━━━━━━━━━━━━━━━━
    "clipboard"
    "mayowa-ojo/tap/chmod-cli"

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Development ━━━━━━━━━━━━━━━━━━━━━━━━━━━
    "flit" # possibly https://search.nixos.org/packages?channel=25.05&query=flit

    # ━━━━━━━━━━━━━━━━━━━━━━━━━ Git & Version Control ━━━━━━━━━━━━━━━━━━━━━━━━━
    "czg"

    # ━━━━━━━━━━━━━━━━━━━━━━━━━ Networking ━━━━━━━━━━━━━━━━━━━━━━━━━
    "ucspi-tcp"
    "zrok"

    # ━━━━━━━━━━━━━━━━━━━━━━━━━ Creative & Media ━━━━━━━━━━━━━━━━━━━━━━━━━
    "huggingface-cli"

    # ━━━━━━━━━━━━━━━━━━━━━━━━━ TeX & Docs ━━━━━━━━━━━━━━━━━━━━━━━━━
    "latexindent"

    # --- Literally just claude-code

  ];

  casks = [
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Development ━━━━━━━━━━━━━━━━━━━━━━━━━━━
    "netron" # On nixpkgs but not darwin
    "postman"

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Communication ━━━━━━━━━━━━━━━━━━━━━━━━━━━
    "signal"
    "whatsapp"

    # ━━━━━━━━━━━━━━━━━━━━━━━━ Media & Creative ━━━━━━━━━━━━━━━━━━━━━━━━
    "adobe-creative-cloud"
    "clipgrab"
    "loom"
    "obs"
    "vlc"

    # ━━━━━━━━━━━━━━━━━━━━━━━ Productivity & Utilities ━━━━━━━━━━━━━━━━━━━━━━━
    "applite"
    "flux-app"
    "bartender"
    "spotify" # For some reason, the nixpkgs version is breaking

    # ━━━━━━━━━━━━━━━━━━━━━━━━ Office & Knowledge ━━━━━━━━━━━━━━━━━━━━━━━━
    "dropbox"
    "freedom"
    "memory"
    "microsoft-auto-update"
    "microsoft-office"
    "notion"
    "notion-calendar"
    "notion-mail"
    "cleanshot"
    "notunes"

    # ━━━━━━━━━━━━━━━━━━━━━━━ Security & Terminals ━━━━━━━━━━━━━━━━━━━━━━━
    "burp-suite"
    "ghostty"
    "protonvpn"
    "qflipper"

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Gaming ━━━━━━━━━━━━━━━━━━━━━━━━━━━
    "epic-games"
    "gog-galaxy"
    "minecraft"
    "steam"

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ AI ━━━━━━━━━━━━━━━━━━━━━━━━━━━
    "claude"

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━ Fonts ━━━━━━━━━━━━━━━━━━━━━━━━━━━
    "font-nova-round"
  ];

  masApps = {
    "image2icon" = 992115977;
    # Xcode = 497799835; # Note: Takes almost an hour to download, skip for fast install
    # "1Password for Safari" = 1569813296;
  };
}
