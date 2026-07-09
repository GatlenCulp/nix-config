-- Ported from nvix plugins/treesitter.nix
-- nixvim installed all grammars via Nix; here we pin an explicit list covering
-- every language configured in this setup and compile at runtime (:TSUpdate).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Pin to the frozen `master` branch: the new default `main` branch is an
    -- incompatible rewrite that removes `nvim-treesitter.configs`,
    -- `ensure_installed`, `highlight`, and `indent` (used below). Staying on
    -- master keeps this config working on Neovim 0.11.
    branch = "master",
    lazy = false, -- nixvim loaded treesitter eagerly
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash",
        "bibtex",
        "c",
        "cmake",
        "cpp",
        "css",
        "csv",
        "diff",
        "dockerfile",
        "editorconfig",
        "fish",
        "gitattributes",
        "gitcommit",
        "git_config",
        "git_rebase",
        "gitignore",
        "go",
        "haskell",
        "html",
        "http",
        "ini",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "latex",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "nix",
        "printf",
        "python",
        "query",
        "regex",
        "rst",
        "rust",
        "scss",
        "sql",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      highlight = {
        enable = true,
        disable = { "latex", "markdown" },
      },
      -- `indent_enable` in the nix source was intended as indent.enable
      indent = { enable = true },
      incremental_selection = { enable = true },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      max_lines = 4,
      min_window_height = 40,
    },
  },

  -- plugins.mini-ai (standalone module in nixvim)
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {},
  },

  -- tpope's indent fixes
  {
    "tpope/vim-sleuth",
    lazy = false,
  },
}
