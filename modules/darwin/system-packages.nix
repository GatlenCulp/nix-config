{ pkgs }:

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
    ];

    communication = [
      slack
      zoom-us
    ];

    data-config = [
      sqlite
      sqlfluff
      taplo
      qsv # Working with CSV files (miller (multiple files), xan (more analysis), csvkit are alternatives)
    ];

    dev-utils = [
      chezmoi
      graphviz
      rich-cli
    ];

    devops = [
      act
      # awscli
      devcontainer
      docker
      orbstack
      hadolint
      terraform
    ];

    docs = [
      markdownlint-cli
      mdformat
      pandoc
    ];

    editors = [
      code-cursor
      lunarvim
      warp-terminal
      windsurf
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
      pre-commit
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
    ];

    nix = [
      nixd
      statix
      nixdoc
      nixfmt-rfc-style # Alejandra is an alternative, but this is fine tbh https://github.com/kamadorueda/alejandra
      cabal-install # haskell but needed for nixfmt sometimes
      nixfmt-tree # only for nix formatting recursively
      treefmt # all-in-one formatter using a nix setup
    ];

    productivity = [
      # bartender # Only version 5
      lastpass-cli
      raycast
      # spotify
      tailscale
      zotero
      desktoppr # Hopefully works
    ];

    python = [
      cookiecutter
      cruft
      nbqa
      pyright
      python3
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

    # Retired
    # retired = [
    #   claude-code
    #   discord
    #   tldr # Testing out tealdeer
    # ];

    # Unsupported on darwin (future)
    # darwin-future = [
    #   clipgrab             # unsupported on darwin
    #   ghostty              # broken on darwin
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
    #   orbstack             # not packaged in nixpkgs
    # ];
  };

  # Default selection: include all profiles to preserve current behavior.
  selected = with profiles; [
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
    security
    shell
    typst
    web
  ];
in
builtins.concatLists selected
