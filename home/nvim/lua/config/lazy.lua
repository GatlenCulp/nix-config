-- Standard lazy.nvim bootstrap (https://lazy.folke.io/installation).
-- Plugins are cloned by lazy.nvim into stdpath("data")/lazy on first launch;
-- Nix only provides the nvim binary and external toolchain (see default.nix).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Options (incl. leader keys), keymaps and autocmds must be in place before
-- lazy.nvim loads any plugin spec (same ordering nixvim used).
require("config.options")
require("config.keymaps")
require("config.autocmds")

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "dracula" } },
  checker = { enabled = false },
})
