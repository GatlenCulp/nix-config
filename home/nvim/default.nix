# Neovim, live-editable lazy.nvim edition (replaces the nixvim/nvix module,
# preserved in home/_legacy/nvim-nixvim).
#
# Split of responsibilities:
#   - Nix installs the nvim binary + every external tool the config shells out
#     to (LSP servers, formatters, pickers' grep/fd, lazygit, ...).
#   - lazy.nvim clones/updates the plugins themselves at runtime (network on
#     first launch); pin them by committing lazy-lock.json once it appears.
#   - ~/.config/nvim is an out-of-store symlink into this repo, so edits apply
#     instantly without a rebuild and flow back into git.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  flakeDir = "${config.home.homeDirectory}/.config/nix-config";
in
{
  # Live-editable config (mkOutOfStoreSymlink, same pattern as home/ghostty).
  # The directory also contains default.nix/README.md/stylua.toml — harmless,
  # nvim only loads init.lua and lua/.
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/nvim";

  # programs.neovim is intentionally NOT used: the plain package avoids
  # home-manager's wrapper/init.lua generation fighting the symlinked config.
  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  home.packages =
    with pkgs;
    [
      neovim

      ### Core toolchain (bootstrap, treesitter grammar builds, plugin installs)
      git
      curl
      gcc # tree-sitter grammar compilation (:TSUpdate)
      tree-sitter # CLI for generated grammars (e.g. latex)
      nodejs # copilot.lua agent, markdown-preview server, some grammars

      ### Pickers / git UI (snacks.nvim dashboard + pickers, Snacks.lazygit)
      ripgrep
      fd
      lazygit
      gh # dashboard panes; `gh notify` needs `gh extension install meiji163/gh-notify` (manual)
      dwt1-shell-color-scripts # dashboard `colorscript -e square` pane

      ### Image / document rendering (snacks.image, img-clip)
      imagemagick
      ghostscript_headless
      tectonic
      mermaid-cli

      ### AI
      claude-code # greggh/claude-code.nvim drives the `claude` CLI

      ### LSP servers
      typos-lsp
      pyright
      ruff # runs as LSP and formatter
      bash-language-server
      shellcheck # used by bashls for diagnostics (and conform)
      taplo # toml LSP + formatter
      tinymist # typst LSP (also used by typst-preview)
      haskell-language-server # nvix set installGhc=false; ghc not required
      nixd
      statix
      lua-language-server
      typescript-language-server
      typescript # tsserver lib
      tailwindcss-language-server
      nodePackages.svelte-language-server
      vscode-langservers-extracted # jsonls, html, cssls, eslint
      emmet-ls
      biome
      texlab

      ### Formatters (conform.nvim resolves these from $PATH)
      coreutils # `cat` for the squeeze_blanks formatter
      libxml2 # xmllint
      yamlfix
      stylua
      nixfmt-rfc-style # binary name `nixfmt`
      shellharden
      shfmt
      typstyle

      ### Language extras
      rust-analyzer # rustaceanvim; cargo/rustc come from home/_rust
      websocat # typst-preview + kulala websockets
      glow # glow.nvim markdown TUI preview
      pandoc # md-pdf.nvim
      python3Packages.pylatexenc # tex.nix extraPackages (manifest said python313Packages; unpinned here)

      # fixjson: conform json formatter. TODO(verify attr): top-level `fixjson`
      # may not exist on this channel; nodePackages.fixjson is the historical attr.
      nodePackages.fixjson
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      pngpaste # img-clip.nvim clipboard images (darwin-only tool)
    ];

  # NOT included (deliberately):
  #   - texlive.combined.scheme-full — multi-GB. vimtex needs latexmk/pdflatex
  #     etc., but home/_tex adds /Library/TeX/texbin to sessionPath (MacTeX),
  #     so the system TeX install already provides them. Uncomment if you want
  #     a Nix-managed TeX instead:
  # home.packages = [ pkgs.texlive.combined.scheme-full ];
  #   - typst — optional; tinymist handles compile/preview.
  #   - grpcurl — optional kulala.nvim gRPC support.
  #   - tmux — only needed for vim-tmux-navigator/smart-splits inside tmux.
}
