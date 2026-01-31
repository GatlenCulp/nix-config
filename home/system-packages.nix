{ pkgs, ... }:

with pkgs;
let
  # Profiles. Select subsets later; for now we concatenate them all.
  profiles = {
    browsers = [
      brave
      google-chrome
      tor
    ];

    build-tools = [
      actionlint
      go-task
      just
      yo
      gnumake
    ];

    communication = [
      slack
      zoom-us
    ];

    data-config = [
      # sqlite # Don't need this second
      sqlfluff # SQL linter?
      duckdb # Type of database, similar to SQLite
      taplo # TOML
      qsv # Working with CSV files (miller (multiple files), xan (more analysis), csvkit are alternatives)
    ];

    ai = [
      # open-webuil
    ];

    dev-utils = [
      # chezmoi # Pure nix now
      graphviz
      rich-cli
    ];

    devops = [
      act
      devcontainer
      # docker # I think orbstack can replace this
      orbstack
      hadolint
      terraform
      devenv # Temporarily disabled - re-enable after rebuild
    ];

    docs = [
      markdownlint-cli
      mdformat
      pandoc
    ];

    editors = [
      code-cursor
      # lunarvim
      warp-terminal
      # windsurf
      vimgolf
    ];

    file-ops = [
      brotli
      curl
      gnugrep
      gnutar
      ov
      poppler
      subversion # Used for downloading individual github directories
      tre
      xz
    ];

    formatters-linters = [
      checkmake
      nodePackages.cspell
      oxipng
      # pre-commit
      prek
    ];

    lean = [ lean4 ];

    media = [
      # blender
      charm-freeze
      vhs
    ];

    misc = [ neo-cowsay ];

    networking = [
      dns2tcp
      nmap
      openvpn
      socat
      sshs
      syncthing
      tcpflow
      tcpreplay
      xxh
      curlie # curl with httpie
      httpie
      wget
      transmission_4 # Only the CLI
      # cloudflare-warp # Using CloudFlare infrastructure for faster connection (plus 1.1.1.1)
    ];

    productivity = [
      # bartender # Only version 5, use homebrew
      lastpass-cli
      raycast
      # spotify
      tailscale # I think just the cli
      zotero
      # mailspring # eh, not a huge fan
    ];

    security = [
      aircrack-ng
      fcrackzip
      john
      knockpy
      metasploit
      sqlmap
      wireshark
    ];

    web = [
      biome
      nodejs_24
      prettierd
    ];

    cli = [
      sad # CLI search and replace, just like sed, but with diff preview.
      yq-go # yaml processor https://github.com/mikefarah/yq
      jc # converts the output of popular cli tools & file-types to JSON, YAML

      # Disk Usage
      duf # Disk Usage/Free Utility - a better 'df' alternative
      dust # A more intuitive version of `du` in rust
      gdu # disk usage analyzer(replacement of `du`)
      ncdu # analyzer your disk usage Interactively, via TUI(replacement of `du`)
      which
      procs # a moreden ps

    ];

    vms = [
      utm
    ];

    # Unsupported on darwin (future)
    darwin-future = [
    #   clipgrab             # unsupported on darwin
    #   minecraft            # broken on darwin
    #   netron               # unsupported on darwin
    #   notion               # unsupported on darwin
    #   obs-studio           # unsupported on darwin
    #   postman              # broken on darwin
    #   signal-desktop       # unsupported on darwin
    #   ucspi-tcp            # unsupported on darwin
    #   whatsapp-for-mac     # broken on darwin
    #   zrok                 # unsupported on darwin
    ];

    # Not packaged (future)
    # not-packaged = [
    #   # Comet by Perplexity  # not in nixpkgs or brew
    # ];
  };

  # Default selection: include all profiles to preserve current behavior.
  selected = with profiles; [
    ai
    browsers
    build-tools
    communication
    data-config
    dev-utils
    devops
    docs
    editors
    file-ops
    formatters-linters
    lean
    media
    misc
    networking
    productivity
    # security # Don't need rn
    web
    cli
    vms
    darwin-future
  ];
in
{
  environment.systemPackages = builtins.concatLists selected;
  # home.packages = builtins.concatLists selected;
}
