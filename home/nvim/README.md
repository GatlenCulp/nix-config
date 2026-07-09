# nvim — live-editable lazy.nvim config

Port of the old nixvim/nvix setup (preserved in `home/_legacy/nvim-nixvim`) to a
plain lazy.nvim config that is symlinked (out-of-store) into `~/.config/nvim`,
so edits apply instantly without a rebuild and flow back into git.

## Architecture

| Layer | Owner |
|---|---|
| `nvim` binary + external tools (LSPs, formatters, rg/fd, lazygit, ...) | Nix — `default.nix` `home.packages` |
| Config (`init.lua`, `lua/config/`, `lua/plugins/`) | This directory, symlinked via `mkOutOfStoreSymlink` |
| Plugins | lazy.nvim clones them at runtime into `~/.local/share/nvim/lazy` |
| Plugin pinning | `lazy-lock.json` — lands here on first run; commit it |

First launch after `darwin-rebuild switch`: run `nvim`, lazy.nvim bootstraps
itself and installs all plugins; verify with `:checkhealth lazy`.

## Layout

- `init.lua` → `lua/config/lazy.lua` (bootstrap; `spec = { { import = "plugins" } }`)
- `lua/config/options.lua` — options, globals (`mapleader = " "`,
  `maplocalleader = " t"`), undercurl highlights, SSH/OSC52 clipboard,
  diagnostic sign glyphs
- `lua/config/keymaps.lua` — plain keymaps (plugin-owned keymaps live on their
  lazy specs)
- `lua/config/autocmds.lua` — yank highlight, checktime
- `lua/plugins/*.lua` — one file per ported cluster

## Cross-file conventions

- **nvim-lspconfig**: `lsp.lua` owns the single `config` handler; it iterates
  the lazy-merged `opts.servers` with `vim.lsp.config()`/`vim.lsp.enable()`.
  `lang.lua` and `tex.lua` contribute servers as `opts.servers` fragments only.
- **conform.nvim**: `lsp.lua` owns the core opts (default_format_opts, `_`
  fallback); `lang.lua` merges `formatters_by_ft` for concrete filetypes.
- **which-key**: `editor.lua` owns the plugin; other files add group icons via
  `optional = true` spec fragments or pcall-guarded `wk.add()`.
- **colorscheme**: `colorscheme.lua` is the single owner of dracula.nvim
  (priority 1000 + `vim.cmd.colorscheme`).
- Formatting: `stylua.toml` (2-space, 120 cols); run `stylua .` from this dir.

## Manual steps

- **gh-notify**: the dashboard's notifications pane runs `gh notify`, a gh
  *extension* not packaged in nixpkgs — install once with
  `gh extension install meiji163/gh-notify`.
- **Firenvim**: install the browser extension in Firefox/Chrome; the lazy
  `build` step (`:call firenvim#install(0)`) writes the native-messaging
  manifest.
- **Copilot**: authenticate once with `:Copilot auth`.
- **TeX**: `texlive.combined.scheme-full` is NOT installed via Nix (multi-GB);
  `home/_tex` puts MacTeX's `/Library/TeX/texbin` on PATH instead. See
  `default.nix` to switch to Nix-managed TeX.

## Not ported from nixvim/nvix (full port manifests are in the PR description)

- `plugins.lz-n` — obsolete; lazy.nvim is the loader now.
- `colorschemes.catppuccin` / `tokyonight` — were `enable = false` upstream.
- `luaLoader.enable = false` — lazy.nvim's own cache policy is used instead.
- `extraLuaPackages = [ luarocks ]` — nothing in this config needs luarocks.
- `plugins.otter` — was disabled upstream; `<leader>lO` is pcall-guarded.
- hls `installGhc`/`packageFallback`, conform Nix-store formatter paths,
  vimtex `texlivePackage` — Nix-side install knobs replaced by `home.packages`.

## Intentional fixes / deviations (vs. bug-for-bug fidelity)

- `<leader>bc` → `:BufferLineCloseOthers` (source had nonexistent
  `:BufferLineCloseOther`).
- gitsigns `]h` leading-space typo fixed (`" ]c"` → `"]c"`).
- `arminveres/md-pdf.nvim` added — nvix mapped `<leader>pp` to it without
  installing it (the mapping errored upstream).
- which-key presets moved to `plugins.presets` (v3 schema).
- Deprecated APIs modernized: `vim.diagnostic.jump`, `source = true`,
  `vim.diagnostic.enable(bool)`.
- blink.cmp wired to LuaSnip (`snippets.preset = "luasnip"`) and LSP
  capabilities — implied but never wired in nixvim.
- dracula.nvim still receives the tokyonight-shaped keys it ignores (verbatim
  port; set `transparent_bg = true` for real transparency).
