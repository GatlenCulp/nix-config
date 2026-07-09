-- Ported from nvix plugins/firenvim.nix.
-- nixvim plugins.firenvim.settings maps to vim.g.firenvim_config.
return {
  {
    "glacambre/firenvim",
    -- only load eagerly when nvim was started by the browser extension
    lazy = not vim.g.started_by_firenvim,
    build = ":call firenvim#install(0)",
    init = function()
      vim.g.firenvim_config = {
        globalSettings = {
          cmdline = "neovim",
          content = "text",
          priority = 0,
          selector = "textarea",
          takeover = "never",
        },
        localSettings = {
          [".*"] = {
            takeover = "never",
            cmdline = "neovim",
          },
        },
      }
    end,
  },
}
