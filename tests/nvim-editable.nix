# Hermetic unit tests for the nixvim -> lazy.nvim migration.
#
# Imports home/nvim/default.nix as a plain function with mocked
# `config`/`pkgs`/`lib`, so it needs only the Nix evaluator — no home-manager,
# no nix-darwin, no flake inputs, no network. Runnable on Linux CI even though
# the real system config is darwin-only.
#
# Run:  nix eval --raw -f tests/nvim-editable.nix   (or: tests/run-nvim.sh)
let
  homeDir = "/home/gattest";
  flakeDir = "${homeDir}/.config/nix-config";

  # Every pkgs attr referenced by home/nvim/default.nix, mocked as a tagged
  # attrset so home.packages can be inspected structurally.
  mockPkgNames = [
    "git"
    "curl"
    "gcc"
    "tree-sitter"
    "nodejs"
    "ripgrep"
    "fd"
    "lazygit"
    "gh"
    "dwt1-shell-color-scripts"
    "imagemagick"
    "ghostscript_headless"
    "tectonic"
    "mermaid-cli"
    "claude-code"
    "typos-lsp"
    "pyright"
    "ruff"
    "bash-language-server"
    "shellcheck"
    "taplo"
    "tinymist"
    "haskell-language-server"
    "nixd"
    "statix"
    "lua-language-server"
    "typescript-language-server"
    "typescript"
    "tailwindcss-language-server"
    "vscode-langservers-extracted"
    "emmet-ls"
    "biome"
    "texlab"
    "coreutils"
    "libxml2"
    "yamlfix"
    "stylua"
    "nixfmt-rfc-style"
    "shellharden"
    "shfmt"
    "typstyle"
    "rust-analyzer"
    "websocat"
    "glow"
    "pandoc"
    "pngpaste"
  ];
  mkMock = name: {
    __mockPkg = name;
  };
  mockPkgs =
    builtins.listToAttrs (
      map (n: {
        name = n;
        value = mkMock n;
      }) mockPkgNames
    )
    // {
      neovim = {
        __nvim = true;
        __mockPkg = "neovim";
      };
      nodePackages = {
        svelte-language-server = mkMock "nodePackages.svelte-language-server";
        fixjson = mkMock "nodePackages.fixjson";
      };
      python3Packages = {
        pylatexenc = mkMock "python3Packages.pylatexenc";
      };
      stdenv.isDarwin = true;
      stdenv.hostPlatform.isDarwin = true;
    };

  mockArgs = {
    config = {
      home.homeDirectory = homeDir;
      lib.file.mkOutOfStoreSymlink = path: {
        __outOfStoreSymlink = true;
        target = toString path;
      };
    };
    pkgs = mockPkgs;
    lib = {
      optionals = cond: xs: if cond then xs else [ ];
    };
  };

  try =
    e:
    let
      r = builtins.tryEval e;
    in
    if r.success then r.value else null;

  nvimModule = try (import ../home/nvim/default.nix mockArgs);
  moduleOk = nvimModule != null;

  ## (a) symlink target
  entry = if moduleOk then (nvimModule.xdg.configFile."nvim" or { }) else { };
  target = try (entry.source.target or null);
  expectedTarget = "${flakeDir}/home/nvim";

  ## (b) pkgs.neovim in home.packages
  packages = if moduleOk then (nvimModule.home.packages or [ ]) else [ ];
  hasNeovim = builtins.any (p: (p.__nvim or false) == true) packages;

  ## (b') vi/vim aliases point at nvim
  aliases = if moduleOk then (nvimModule.home.shellAliases or { }) else { };
  aliasesOk = (aliases.vi or null) == "nvim" && (aliases.vim or null) == "nvim";

  ## (c) legacy module tucked away
  legacyExists = builtins.pathExists ../home/_legacy/nvim-nixvim/default.nix;
  oldGone = !(builtins.pathExists ../home/nixvim);

  ## (d) hosts/gatty.nix imports home/nvim, and no active line references
  ##     home/nixvim or the nixvim/nvix inputs.
  gattyText = builtins.readFile ../hosts/gatty.nix;
  gattyLines = builtins.filter builtins.isString (builtins.split "\n" gattyText);
  isComment = l: builtins.match "[[:space:]]*#.*" l != null;
  activeLines = builtins.filter (l: !isComment l) gattyLines;
  hasIn = pat: l: builtins.match ".*(${pat}).*" l != null;
  gattyHasNvim = builtins.any (hasIn "home/nvim") activeLines;
  gattyNoNixvim = !(builtins.any (hasIn "home/nixvim") activeLines);
  # Bracket expressions keep this file itself out of repo-wide greps for the
  # retired input names.
  gattyNoNvix =
    !(builtins.any (hasIn "[n]vixPlugins|inputs[.][n]vix|[n]ixvim[.]homeModules") activeLines);

  ## (d') same wiring assertions for hosts/server.nix
  serverText = builtins.readFile ../hosts/server.nix;
  serverLines = builtins.filter builtins.isString (builtins.split "\n" serverText);
  serverActive = builtins.filter (l: !isComment l) serverLines;
  serverHasNvim = builtins.any (hasIn "home/nvim") serverActive;
  serverNoNixvim = !(builtins.any (hasIn "home/nixvim") serverActive);
  serverNoNvix =
    !(builtins.any (hasIn "[n]vixPlugins|inputs[.][n]vix|[n]ixvim[.]homeModules") serverActive);

  checks = [
    {
      name = "home/nvim/default.nix imports as a plain module (mock eval)";
      ok = moduleOk;
      detail = "moduleOk=${toString moduleOk}";
    }
    {
      name = "nvim: ~/.config/nvim is an out-of-store symlink to the repo dir";
      ok = target == expectedTarget;
      detail = "got=${toString target} expected=${expectedTarget}";
    }
    {
      name = "nvim: pkgs.neovim present in home.packages";
      ok = hasNeovim;
      detail = "packages=${toString (builtins.length packages)}";
    }
    {
      name = "nvim: vi/vim shell aliases map to nvim";
      ok = aliasesOk;
      detail = "vi=${toString (aliases.vi or null)} vim=${toString (aliases.vim or null)}";
    }
    {
      name = "legacy: home/_legacy/nvim-nixvim/default.nix exists";
      ok = legacyExists;
      detail = "exists=${toString legacyExists}";
    }
    {
      name = "legacy: home/nixvim no longer exists";
      ok = oldGone;
      detail = "gone=${toString oldGone}";
    }
    {
      name = "hosts/gatty.nix: imports home/nvim";
      ok = gattyHasNvim;
      detail = "";
    }
    {
      name = "hosts/gatty.nix: no active line references home/nixvim";
      ok = gattyNoNixvim;
      detail = "";
    }
    {
      name = "hosts/gatty.nix: no active nixvim/nvix module wiring remains";
      ok = gattyNoNvix;
      detail = "";
    }
    {
      name = "hosts/server.nix: imports home/nvim";
      ok = serverHasNvim;
      detail = "";
    }
    {
      name = "hosts/server.nix: no active line references home/nixvim";
      ok = serverNoNixvim;
      detail = "";
    }
    {
      name = "hosts/server.nix: no active nixvim/nvix module wiring remains";
      ok = serverNoNvix;
      detail = "";
    }
  ];

  fmt =
    c:
    "  [${if c.ok then "PASS" else "FAIL"}] ${c.name}"
    + (if c.ok || c.detail == "" then "" else "\n         ${c.detail}");
  lines = builtins.concatStringsSep "\n" (map fmt checks);
  passed = builtins.length (builtins.filter (c: c.ok) checks);
  total = builtins.length checks;
in
lines
+ "\n\n${toString passed}/${toString total} passed"
+ (if passed == total then "\nRESULT: ALL PASS" else "\nRESULT: SOME FAIL")
