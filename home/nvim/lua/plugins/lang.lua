-- Ported from nvix plugins/lang/ (default, haskell, lua, md, nix, python,
-- rust, shell, toml, typst, webdev).
--
-- LSP servers are contributed to the shared `opts.servers` table on
-- nvim-lspconfig; lsp.lua owns the single authoritative `config` handler
-- that consumes the merged `opts.servers`.

local shell_formatters = { "shellcheck", "shellharden", "shfmt" }

-- plugins.lsp.servers.* from lang/*.nix
local servers = {
  -- lang/haskell.nix (installGhc/packageFallback are Nix-only install knobs)
  hls = {},
  -- lang/lua.nix
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          disable = { "miss-name" },
          globals = { "vim", "cmp", "Snacks" },
        },
      },
    },
  },
  -- lang/nix.nix
  nixd = {},
  statix = {},
  -- lang/python.nix
  ruff = {},
  pyright = {
    settings = {
      pyright = { disableOrganizeImports = true },
      python = { analysis = { ignore = { "*" } } },
    },
  },
  -- lang/shell.nix
  bashls = {},
  -- lang/toml.nix
  taplo = {},
  -- lang/typst.nix
  tinymist = {},
  -- lang/webdev.nix
  ts_ls = {},
  tailwindcss = {},
  svelte = {},
  jsonls = {},
  html = {},
  eslint = {},
  emmet_ls = {},
  cssls = {},
  biome = {},
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, servers)
    end,
  },

  -- Formatters (conform core setup is owned by the lsp cluster; fts here are
  -- disjoint so opts deep-merge cleanly). Commands resolve from $PATH via
  -- conform's built-in formatter definitions (nixvim pinned Nix store paths).
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- lang/default.nix
        xml = { "xmllint" },
        yaml = { "yamlfix" },
        json = { "fixjson" },
        -- lang/lua.nix
        lua = { "stylua" },
        -- lang/nix.nix (nixfmt-rfc-style binary is `nixfmt`)
        nix = { "nixfmt" },
        -- lang/shell.nix
        bash = shell_formatters,
        sh = shell_formatters,
        zsh = shell_formatters,
        -- lang/toml.nix (conform's builtin taplo already passes `format`)
        toml = { "taplo" },
        -- lang/typst.nix
        typst = { "typstyle" },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- lang/md.nix — markdown
  ---------------------------------------------------------------------------
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_echo_preview_url = 1
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    opts = {
      to_do = { symbols = { " ", "⧖", "x" } },
      mappings = {
        MkdnEnter = { { "n", "i" }, "<cr>" },
        MkdnToggleToDo = { { "n", "i" }, "<c-space>" },
      },
    },
    -- autoCmd from lang/md.nix: buffer-local preview keymaps
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Setup Markdown mappings",
        pattern = "markdown",
        callback = function()
          local opts = { noremap = true, silent = true }
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<leader>pg",
            "<cmd>Glow<CR>",
            vim.tbl_extend("force", opts, { desc = "Markdown Glow preview" })
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<leader>pb",
            "<cmd>MarkdownPreview<CR>",
            vim.tbl_extend("force", opts, { desc = "Markdown Browser Preview" })
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<leader>pp",
            '<cmd> lua require("md-pdf").convert_md_to_pdf()<CR>',
            vim.tbl_extend("force", opts, { desc = "Markdown Print pdf" })
          )
        end,
      })
    end,
  },
  -- The <leader>pp mapping referenced md-pdf but nvix never installed it;
  -- added here so the mapping actually works (see manifest).
  {
    "arminveres/md-pdf.nvim",
    ft = "markdown",
    branch = "main",
    opts = {},
  },
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    cmd = "Glow",
    opts = {},
  },

  ---------------------------------------------------------------------------
  -- lang/rust.nix
  ---------------------------------------------------------------------------
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false, -- plugin lazy-loads itself; upstream recommends lazy = false
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {},
  },

  ---------------------------------------------------------------------------
  -- lang/typst.nix
  ---------------------------------------------------------------------------
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    opts = {
      -- nixvim wired these to Nix store paths; resolve from $PATH instead of
      -- letting the plugin download binaries.
      dependencies_bin = {
        tinymist = "tinymist",
        websocat = "websocat",
      },
    },
  },

  ---------------------------------------------------------------------------
  -- lang/webdev.nix
  ---------------------------------------------------------------------------
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- which-key groups (wKeyList entries from md.nix and webdev.nix)
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>p", group = "preview" },
        { "<leader>R", group = "Http Requests", icon = "󱞒" },
      })
    end,
  },
}
