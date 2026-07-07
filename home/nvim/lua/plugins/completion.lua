-- Ported from nvix: plugins/blink-cmp.nix (blink-cmp + luasnip)

return {
  { "L3MON4D3/LuaSnip" },

  {
    "saghen/blink.cmp",
    -- use a release tag so lazy.nvim downloads the prebuilt fuzzy-matcher lib
    version = "1.*",
    event = "InsertEnter",
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      -- nixvim enabled luasnip alongside blink; wire it in explicitly here
      snippets = { preset = "luasnip" },
      completion = { menu = { border = "rounded" } },
      keymap = {
        preset = "default",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-space>"] = {
          -- verbatim from nvix: accept copilot suggestion if visible, else accept
          function(cmp)
            local ok, _ = pcall(require, "copilot")
            if ok then
              vim.g.copilot_no_tab_map = true
              vim.g.copilot_assume_mapped = true
              vim.g.copilot_tab_fallback = ""

              local suggestion = require("copilot.suggestion")
              if suggestion.is_visible() then
                suggestion.accept()
              else
                if cmp.snippet_active() then
                  return cmp.select_and_accept()
                else
                  return cmp.accept()
                end
              end
            end
          end,
        },
      },
    },
  },
}
