-- Ported from nvix plugins/common/default.nix (globals, opts, extraConfigLua)
-- and plugins/common/plugins.nix opts. Runs before lazy.setup().

---------------------------------------------------------------------------
-- Globals
---------------------------------------------------------------------------
vim.g.mapleader = " " -- nvix.leader
-- tex.nix set globals.maplocalleader = " t" (multi-key localleader = <space>t);
-- must be set before plugins (vimtex) load.
vim.g.maplocalleader = " t"
vim.g.floating_window_options = { border = "rounded" } -- nvix.border

---------------------------------------------------------------------------
-- Options (common/default.nix `opts`)
---------------------------------------------------------------------------
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.pumblend = 0
vim.opt.pumheight = 10
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.cmdheight = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.ruler = false
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "screen"
vim.opt.termguicolors = true
vim.opt.conceallevel = 2
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.virtualedit = "block"
-- NOTE: windows.nvim config (plugins/editor.lua) later sets winwidth=10,
-- winminwidth=10, equalalways=false, matching nvix's extraConfigLua ordering.
vim.opt.winminwidth = 5
vim.opt.fileencoding = "utf-8"
vim.opt.list = true
vim.opt.smoothscroll = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.swapfile = false
vim.opt.fillchars = { eob = " " }
vim.opt.updatetime = 500
-- from common/plugins.nix opts:
vim.opt.timeout = true
vim.opt.timeoutlen = 250
-- from common/default.nix extraConfigLua:
vim.opt.whichwrap:append("<>[]hl")

---------------------------------------------------------------------------
-- Extra init Lua (common/default.nix extraConfigLua)
---------------------------------------------------------------------------
-- Undercurl diagnostics. These ran before the colorscheme in nvix too; the
-- dracula colorscheme re-highlights undercurl at plugin load.
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true })

-- SSH/OSC52 clipboard (verbatim from nvix)
local function my_paste(reg)
  return function()
    local content = vim.fn.getreg('"')
    -- g:clipboard.paste must return { lines, regtype }; returning only the
    -- lines loses the register type (linewise/blockwise pastes break).
    return { vim.split(content, "\n"), vim.fn.getregtype('"') }
  end
end
if os.getenv("SSH_TTY") ~= nil then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = my_paste("+"),
      ["*"] = my_paste("*"),
    },
  }
end

-- Diagnostic sign icons (nvix icons.diagnostics Bold*:
-- Hint U+EA61, Info U+F05A, Warn U+F071, Error U+F057)
local signs = {
  Hint = "",
  Info = "",
  Warn = "",
  Error = "",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
