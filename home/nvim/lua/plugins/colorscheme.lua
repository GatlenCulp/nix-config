-- Ported from nvix plugins/common/colorscheme.nix
-- dracula-nvim was the enabled colorscheme (catppuccin and tokyonight were disabled).
return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    -- Settings ported verbatim from the nixvim module (nvix.transparent = true).
    -- NOTE: `style`/`transparent`/`styles` are tokyonight-style keys that
    -- dracula.nvim ignores; kept verbatim for fidelity (see README.md).
    opts = {
      style = "night",
      transparent = true,
      styles = {
        floats = "transparent",
        sidebars = "transparent",
        comments = { italic = true },
        functions = { italic = true },
        variables = { italic = true },
        keywords = { italic = true, bold = true },
      },
    },
    config = function(_, opts)
      require("dracula").setup(opts)
      vim.cmd.colorscheme("dracula")
    end,
  },
}
