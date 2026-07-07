-- Ported from nvix plugins/tex.nix (vimtex + texlab + which-key VimTeX menu).
-- nixvim set globals.maplocalleader = " t" (i.e. <leader>t is the localleader
-- prefix); that global lives in lua/config/options.lua, before plugins load.
return {
  {
    "lervag/vimtex",
    lazy = false, -- vimtex handles its own filetype-based lazy loading
    init = function()
      -- extraConfigLuaPre from tex.nix
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = ".build", -- you can set here whatever name you desire
      }
      vim.g.vimtex_quickfix_ignore_filters = { "warning" }
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_mappings_enabled = 0
    end,
    config = function()
      -- https://github.com/lervag/vimtex/wiki/which-key.nvim-support
      local ok, wk = pcall(require, "which-key")
      if not ok then
        return
      end
      wk.add({
        { "<leader>t", group = "tex" },
        {
          "<localleader>l",
          group = "VimTeX",
          icon = { icon = "", color = "green" },
          mode = { "n", "x" },
        },
        {
          "<localleader>ll",
          "<plug>(vimtex-compile)",
          desc = "Compile",
          mode = "n",
          icon = { icon = "", color = "green" },
        },
        {
          "<localleader>lL",
          "<plug>(vimtex-compile-selected)",
          desc = "Compile selected",
          mode = { "n", "x" },
          icon = { icon = "", color = "green" },
        },
        {
          "<localleader>li",
          "<plug>(vimtex-info)",
          desc = "Information",
          mode = "n",
          icon = { icon = "", color = "purple" },
        },
        {
          "<localleader>lI",
          "<plug>(vimtex-info-full)",
          desc = "Full information",
          mode = "n",
          icon = { icon = "󰙎", color = "purple" },
        },
        {
          "<localleader>lt",
          "<plug>(vimtex-toc-open)",
          desc = "Table of Contents",
          mode = "n",
          icon = { icon = "󰠶", color = "purple" },
        },
        {
          "<localleader>lT",
          "<plug>(vimtex-toc-toggle)",
          desc = "Toggle table of Contents",
          mode = "n",
          icon = { icon = "󰠶", color = "purple" },
        },
        {
          "<localleader>lq",
          "<plug>(vimtex-log)",
          desc = "Log",
          mode = "n",
          icon = { icon = "", color = "purple" },
        },
        {
          "<localleader>lv",
          "<plug>(vimtex-view)",
          desc = "View",
          mode = "n",
          icon = { icon = "", color = "green" },
        },
        {
          "<localleader>lr",
          "<plug>(vimtex-reverse-search)",
          desc = "Reverse search",
          mode = "n",
          icon = { icon = "", color = "purple" },
        },
        {
          "<localleader>lk",
          "<plug>(vimtex-stop)",
          desc = "Stop",
          mode = "n",
          icon = { icon = "", color = "red" },
        },
        {
          "<localleader>lK",
          "<plug>(vimtex-stop-all)",
          desc = "Stop all",
          mode = "n",
          icon = { icon = "󰓛", color = "red" },
        },
        {
          "<localleader>le",
          "<plug>(vimtex-errors)",
          desc = "Errors",
          mode = "n",
          icon = { icon = "", color = "red" },
        },
        {
          "<localleader>lo",
          "<plug>(vimtex-compile-output)",
          desc = "Compile output",
          mode = "n",
          icon = { icon = "", color = "purple" },
        },
        {
          "<localleader>lg",
          "<plug>(vimtex-status)",
          desc = "Status",
          mode = "n",
          icon = { icon = "󱖫", color = "purple" },
        },
        {
          "<localleader>lG",
          "<plug>(vimtex-status-full)",
          desc = "Full status",
          mode = "n",
          icon = { icon = "󱖫", color = "purple" },
        },
        {
          "<localleader>lc",
          "<plug>(vimtex-clean)",
          desc = "Clean",
          mode = "n",
          icon = { icon = "󰃢", color = "orange" },
        },
        {
          "<localleader>lh",
          "<Cmd>VimtexClearCache ALL<cr>",
          desc = "Clear all cache",
          mode = "n",
          icon = { icon = "󰃢", color = "grey" },
        },
        {
          "<localleader>lC",
          "<plug>(vimtex-clean-full)",
          desc = "Full clean",
          mode = "n",
          icon = { icon = "󰃢", color = "red" },
        },
        {
          "<localleader>lx",
          "<plug>(vimtex-reload)",
          desc = "Reload",
          mode = "n",
          icon = { icon = "󰑓", color = "green" },
        },
        {
          "<localleader>lX",
          "<plug>(vimtex-reload-state)",
          desc = "Reload state",
          mode = "n",
          icon = { icon = "󰑓", color = "cyan" },
        },
        {
          "<localleader>lm",
          "<plug>(vimtex-imaps-list)",
          desc = "Input mappings",
          mode = "n",
          icon = { icon = "", color = "purple" },
        },
        {
          "<localleader>ls",
          "<plug>(vimtex-toggle-main)",
          desc = "Toggle main",
          mode = "n",
          icon = { icon = "󱪚", color = "green" },
        },
        {
          "<localleader>la",
          "<plug>(vimtex-context-menu)",
          desc = "Context menu",
          mode = "n",
          icon = { icon = "󰮫", color = "purple" },
        },
      })
    end,
  },

  -- plugins.lsp.servers.texlab (contributed to the shared servers table;
  -- lsp.lua owns the consuming `config` handler on nvim-lspconfig)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.texlab = opts.servers.texlab or {}
    end,
  },
}
