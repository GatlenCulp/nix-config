-- Ported from nvix: plugins/lsp/{default.nix,mappings.nix,conform.nix}.
-- nvix.border resolved to "rounded". Leader is <space> (set in lua/config).
-- LSP/formatter binaries come from Nix (home.packages) — no mason.
--
-- nvim-lspconfig ownership: THIS file owns the authoritative `config` handler,
-- which consumes `opts.servers` (merged by lazy.nvim across spec fragments).
-- lang.lua and tex.lua contribute their servers as `opts.servers` fragments
-- only. This file contributes the lsp-cluster server (typos_lsp) the same way.

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      servers = {
        -- plugins/lsp/default.nix
        typos_lsp = {
          init_options = { diagnosticSeverity = "Hint" },
        },
      },
    },
    config = function(_, opts)
      -- diagnostic.settings from plugins/lsp/default.nix
      vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        signs = true,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true, -- nvix had "always" (deprecated spelling of true)
          focusable = false,
        },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      for name, cfg in pairs(opts.servers or {}) do
        if cfg then
          if type(cfg) ~= "table" then
            cfg = {}
          end
          cfg.capabilities = capabilities
          vim.lsp.config(name, cfg)
          vim.lsp.enable(name)
        end
      end

      -- plugins.lsp.inlayHints = true
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nvix-lsp-inlay-hints", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })

      -- which-key groups from mappings.nix wKeyList (which-key owned by another cluster)
      local ok_wk, wk = pcall(require, "which-key")
      if ok_wk then
        wk.add({
          { "<leader>l", group = "lsp", icon = "󰿘" },
          { "<leader>lg", group = "goto", icon = "" },
        })
      end

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      -- plugins.lsp.keymaps.diagnostic
      map("n", "<leader>lj", function()
        vim.diagnostic.jump({ count = 1 })
      end, "Goto Next Diagnostic")
      map("n", "<leader>lk", function()
        vim.diagnostic.jump({ count = -1 })
      end, "Goto Prev Diagnostic")

      -- plugins.lsp.keymaps.extra (mappings.nix). Otter is disabled/not installed
      -- in nvix, so <leader>lO is guarded here instead of erroring.
      map("n", "<leader>lO", function()
        local ok_otter, otter = pcall(require, "otter")
        if ok_otter then
          otter.activate()
        else
          vim.notify("otter.nvim is not installed", vim.log.levels.WARN)
        end
      end, "Force Otter")

      map("n", "<leader>lq", "<CMD>LspStop<Enter>", "Stop LSP")
      map("n", "<leader>li", "<cmd>LspInfo<cr>", "LSP Info")
      -- nvix mapped <leader>ls to both LspStart and the symbol picker; the
      -- picker won (last write), leaving LspStart unreachable. Give LspStart
      -- its own key (<leader>lS) so both work.
      map("n", "<leader>lS", "<CMD>LspStart<Enter>", "Start LSP")
      map("n", "<leader>lR", "<CMD>LspRestart<Enter>", "Restart LSP")

      map("n", "<C-s-k>", "<cmd>:lua vim.lsp.buf.signature_help()<cr>", "Signature Help")
      map("n", "<leader>lD", "<cmd>:lua Snacks.picker.lsp_definitions()<cr>", "Definitions list")
      map("n", "<leader>ls", "<cmd>:lua Snacks.picker.lsp_symbols()<cr>", "Symbols list")

      map("n", "[d", function()
        vim.diagnostic.jump({ count = -1 })
      end, "Previous Diagnostic")
      map("n", "]d", function()
        vim.diagnostic.jump({ count = 1 })
      end, "Next Diagnostic")

      map("n", "<leader>lL", function()
        if vim.g.diagnostics_visible == nil or vim.g.diagnostics_visible then
          vim.g.diagnostics_visible = false
          vim.diagnostic.enable(false)
        else
          vim.g.diagnostics_visible = true
          vim.diagnostic.enable(true)
        end
      end, "Toggle Diagnostics")

      map("n", "<leader>ll", function()
        if vim.diagnostic.config().virtual_text == false then
          vim.diagnostic.config({ virtual_text = { source = true } })
        else
          vim.diagnostic.config({ virtual_text = false })
        end
      end, "Toggle Virtual Text")
    end,
  },

  -- plugins.trouble (lsp/default.nix)
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
  },

  -- plugins.tiny-inline-diagnostic (lsp/default.nix); pairs with virtual_text = false
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- plugins.lspsaga (lsp/default.nix), keymaps from mappings.nix
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lightbulb = {
        enable = false,
        virtual_text = false,
      },
      outline = { keys = { jump = "<cr>" } },
      ui = { border = "rounded" }, -- nvix.border
      scroll_preview = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
    },
    keys = {
      { "<leader>la", "<cmd>:Lspsaga code_action<cr>", desc = "Code Action" },
      { "<leader>lo", "<cmd>Lspsaga outline<cr>", desc = "Outline" },
      { "<leader>lw", "<cmd>Lspsaga show_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Definitions" },
      { "<leader>lr", "<cmd>Lspsaga rename ++project<cr>", desc = "Rename" },
      { "gt", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Type Definitions" },
      { "<leader>l.", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Line Diagnostics" },
      { "gpd", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
      { "gpt", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek Type Definition" },
      { "[e", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Jump Prev Diagnostic" },
      { "]e", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Jump Next Diagnostic" },
      {
        "K",
        function()
          local winid
          local ok, ufo = pcall(require, "ufo")
          if ok then
            winid = ufo.peekFoldedLinesUnderCursor()
          end
          if not winid then
            vim.cmd("Lspsaga hover_doc")
          end
        end,
        desc = "Hover Doc",
      },
    },
  },

  -- plugins.nvim-ufo (lsp/default.nix); fold opts came from the lsp module's `opts`
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return { "lsp", "indent" }
      end,
      preview = {
        mappings = {
          close = "q",
          switch = "K",
        },
      },
    },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close All Folds",
      },
      {
        "zK",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek Folded Lines",
      },
    },
  },

  -- plugins.conform-nvim (lsp/conform.nix); format keymaps from mappings.nix.
  -- Language-specific formatters (stylua, nixfmt, shfmt, ...) live in the lang cluster.
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format()
        end,
        mode = { "n", "x" },
        desc = "Format file",
      },
    },
    opts = {
      default_format_opts = { lsp_format = "prefer" },
      formatters_by_ft = {
        ["_"] = {
          "squeeze_blanks",
          "trim_whitespace",
          "trim_newlines",
        },
      },
      -- nvix pointed this at the Nix store's coreutils `cat`; rely on PATH here
      formatters = {
        squeeze_blanks = { command = "cat" },
      },
    },
  },
}
