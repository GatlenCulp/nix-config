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
      # terraform
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

    git = [
      bfg-repo-cleaner
      check-jsonschema
      commitizen
      cz-cli
      dvc-with-remotes
      git-credential-manager
      git-filter-repo
      git-lfs
      gitkraken
      gitleaks
    ];

    go = [ go ];

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
    ];

    nix = [
      # Language Servers
      nixd
      statix
      deadnix

      # Utils
      nixdoc
      nix-tree # A TUI to visualize the dependency graph of a nix derivation
      # it provides the command `nom` works just like `nix` with more details log output
      nix-output-monitor

      # Formatting
      nixfmt-rfc-style # Alejandra is an alternative, but this is fine tbh https://github.com/kamadorueda/alejandra
      cabal-install # haskell but needed for nixfmt sometimes
      nixfmt-tree # only for nix formatting recursively
      treefmt # all-in-one formatter using a nix setup
    ];

    productivity = [
      # bartender # Only version 5, use homebrew
      lastpass-cli
      raycast
      # spotify
      tailscale
      zotero
      # mailspring # eh, not a huge fan
    ];

    python = [
      cookiecutter
      cruft
      # nbqa  # Temporarily disabled - has broken pre-commit-hooks dependency
      pyright
      python3 # TODO: Perhaps replace with uv
      # pylint
      # validate-pyproject
    ];

    ruby = [ ruby ];

    rust = [
      cargo
      clippy
      rustc
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

    shell = [
      bashate
      powershell
      shellcheck
      shfmt
    ];

    typst = [
      typst
      typstyle
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

    darwin = [
      # duti
    ];

    # Unsupported on darwin (future)
    # darwin-future = [
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
    # ];

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
    git
    go
    lean
    media
    misc
    networking
    nix
    productivity
    python
    ruby
    rust
    # security # Don't need rn
    shell
    typst
    web
    cli
    darwin
  ];
in
{
  environment.systemPackages = builtins.concatLists selected;
  # home.packages = builtins.concatLists selected;
}
