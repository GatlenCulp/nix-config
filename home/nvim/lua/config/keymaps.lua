-- Plain (non-plugin) keymaps, ported from nvix plugins/common/mappings.nix.
-- Plugin-owned keymaps (smart-splits, flash, trim, stay-centered, harpoon,
-- bufferline, auto-session, ...) live on their lazy specs in lua/plugins/.

-- nvix's mkKeymap defaults were { silent = true, noremap = true, remap = true };
-- net effect with vim.keymap.set: { silent = true, remap = true }.
local map = function(mode, lhs, rhs, desc, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true, remap = true, desc = desc }, opts or {}))
end

---------------------------------------------------------------------------
-- Visual mode
---------------------------------------------------------------------------
map("v", "<c-s>", "<esc>:w<cr>", "Saving File")
map("v", "<c-c>", "<esc>", "Escape")
map("v", "<a-j>", ":m '>+1<cr>gv-gv", "Move Selected Line Down")
map("v", "<a-k>", ":m '<lt>-2<CR>gv-gv", "Move Selected Line Up")
map("v", "<", "<gv", "Indent out")
map("v", ">", ">gv", "Indent in")
map("v", "<space>", "<Nop>", "Mapped to Nothing")

---------------------------------------------------------------------------
-- Visual-block (x) expr maps
---------------------------------------------------------------------------
map("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", { expr = true })
map("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", { expr = true })

---------------------------------------------------------------------------
-- Insert mode
---------------------------------------------------------------------------
map("i", "jk", "<esc>", "Normal Mode")
map("i", "<c-s>", "<esc>:w ++p<cr>", "Save file")
map("i", "<a-j>", "<esc>:m .+1<cr>==gi", "Move Line Down")
map("i", "<a-k>", "<esc>:m .-2<cr>==gi", "Move Line Up")

---------------------------------------------------------------------------
-- Normal mode
---------------------------------------------------------------------------
map("n", "<leader>dd", function()
  local any_diff = false
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_get_option_value("diff", { win = w }) then
      any_diff = true
      break
    end
  end
  if any_diff then
    vim.cmd("windo diffoff")
  else
    vim.cmd("windo diffthis")
  end
end, "Toggle Diff the opened windows")

map("n", "<c-s>", "<cmd>w ++p<cr>", "Save the file")
map("n", "<a-+>", "<C-a>", "Increase Number")
map("n", "<a-->", "<C-x>", "Decrease Number")
map("n", "<a-j>", "<cmd>m .+1<cr>==", "Move line Down")
map("n", "<a-k>", "<cmd>m .-2<cr>==", "Move line up")
map("n", "<leader>qq", "<cmd>quitall!<cr>", "Quit!")

map("n", "<leader>qw", function()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  if #wins > 1 then
    local ok, err = pcall(vim.cmd, "close")
    if not ok then
      -- This branch has >1 window, so the failure is not "last window"
      -- (e.g. an unsaved-changes error) — report the actual error.
      vim.notify(err or "Cannot close window!", vim.log.levels.WARN)
    end
  else
    vim.notify("Cannot close the last window!", vim.log.levels.WARN)
  end
end, "Close Window!")

map("n", "<leader><leader>", "<cmd>nohl<cr>", "no highlight!")
map("n", "<esc>", "<esc>:nohlsearch<cr>", "escape")
map("n", "<leader>A", "ggVG", "select All")
map("n", "<leader>|", "<cmd>vsplit<cr>", "vertical split")
map("n", "<leader>-", "<cmd>split<cr>", "horizontal split")
map("n", "<leader>cn", "<cmd>cnext<cr>", "quickfix next")
map("n", "<leader>cp", "<cmd>cprev<cr>", "quickfix prev")
map("n", "<leader>cq", "<cmd>cclose<cr>", "quit quickfix")

map("n", "<leader>id", function()
  local date = "# " .. os.date("%d-%m-%y")
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local new_line = line:sub(1, col) .. date .. line:sub(col + 1)
  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
end, "Insert Date at cursor position")

map("n", "n", "nzzzv", "Move to center")
map("n", "N", "Nzzzv", "Moving to center")

map("n", "<leader>ft", function()
  vim.ui.input({ prompt = "Enter FileType: " }, function(input)
    local ft = input
    if not input or input == "" then
      ft = vim.bo.filetype
    end
    vim.o.filetype = ft
  end)
end, "Set Filetype")

map("n", "<leader>o", function()
  local word = vim.fn.expand("<cfile>")
  if word:match("^https?://") then
    local open_cmd
    if vim.fn.has("macunix") == 1 then
      open_cmd = "open"
    elseif vim.fn.has("unix") == 1 then
      open_cmd = "xdg-open"
    elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
      open_cmd = "start"
    else
      print("Unsupported OS")
      return
    end
    vim.fn.jobstart({ open_cmd, word }, { detach = true })
  elseif vim.fn.filereadable(word) == 1 or vim.fn.isdirectory(word) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(word))
  else
    print("Not a valid file or URL: " .. word)
  end
end, "Open")

map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", { expr = true })
map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", { expr = true })

---------------------------------------------------------------------------
-- Black-hole register + paste maps (mappings.nix extraConfigLua, verbatim)
---------------------------------------------------------------------------
vim.api.nvim_set_keymap("n", "x", '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "X", '"_X', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "c", '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "C", '"_C', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "x", '"_d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "X", '"_d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "c", '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "C", '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "p", '"_dP', { noremap = true, silent = true })
vim.cmd([[
  cnoremap <C-j> <C-n>
  cnoremap <C-k> <C-p>
]])
