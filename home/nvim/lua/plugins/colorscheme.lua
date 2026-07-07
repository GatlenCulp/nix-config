-- Ported from nvix plugins/common/colorscheme.nix
-- dracula-nvim was the enabled colorscheme (catppuccin and tokyonight were disabled).
return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    -- The nixvim module used tokyonight-style keys (style/transparent/styles)
    -- that dracula.nvim ignores. Mapped to dracula.nvim's real options here so
    -- the ported `nvix.transparent = true` intent actually takes effect.
    opts = {
      transparent_bg = true,
      italic_comment = true,
    },
    config = function(_, opts)
      require("dracula").setup(opts)
      vim.cmd.colorscheme("dracula")
    end,
  },
}
