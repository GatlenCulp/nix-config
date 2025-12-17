{ pkgs }:
let

in
{
  # https://github.com/LunarVim/starter.lvim/tree/python-ide
  enable = true;
  viAlias = true;
  vimAlias = true;
  # https://github.com/unblevable/quick-scope
  plugins = with pkgs.vimPlugins; [
    ### Package Manager
    lazy-nvim

    ### Theme / General
    dracula-nvim
    nvim-treesitter.withAllGrammars # Syntax highlighting and parsing abilities. Improves code highlighting and such (what kind of parsing does vim have?)
    telescope-nvim # Extensible fuzzy finder (is there a reason for before/after nvim)
    # TODO: Tree walker for better movements(?)
    # TODO: Nvim file explorer tree
    # .nvim vs .lua files?
    nvim-autopairs # Auto-paired delimiters
    nvim-comment # Comment toggler
    gitsigns-nvim # Gutter symbols for git
    lualine-nvim # Customizable statusline
    which-key-nvim # Popup for keybindings and commands
    nvim-web-devicons # Icons for lualine and other plugins
    neoscroll-nvim # Smooth scrolling
    snacks-nvim # Misc QoL collection
    neotest
    transparent-nvim

    ### AI
    claude-code-nvim

    ### Python
    nvim-dap-python # Python Debugger
    neotest-python
  ];
  # https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/d
  # https://dotfyle.com/GatlenCulp/dotfiles-dotconfig-nvim
  extraLuaConfig = ''
    -- Basic Settings
    vim.opt.number = true                -- Show line numbers
    vim.opt.relativenumber = true        -- Show relative line numbers
    vim.opt.cursorline = true            -- Highlight current line

    -- Indentation
    vim.opt.expandtab = true             -- Use spaces instead of tabs
    vim.opt.shiftwidth = 4               -- Number of auto-indent spaces
    vim.opt.smartindent = true           -- Enable smart indent
    vim.opt.softtabstop = 4             -- Number of spaces per Tab
    vim.opt.tabstop = 4                 -- Number of visual spaces per Tab

    -- Search
    vim.opt.ignorecase = true            -- Case insensitive search
    vim.opt.smartcase = true             -- Smart case search

    -- Visual
    vim.opt.termguicolors = true         -- Enable true colors support
    vim.opt.background = 'dark'          -- Set background color
    vim.opt.showmatch = true             -- Highlight matching brackets
    vim.opt.signcolumn = 'yes'           -- Always show signcolumn

    -- Performance
    vim.opt.updatetime = 300             -- Faster completion
    vim.opt.timeoutlen = 500             -- Faster key sequence completion

    -- File Management
    vim.opt.swapfile = false             -- Disable swap file
    vim.opt.undofile = true              -- Enable persistent undo
    vim.opt.undodir = vim.fn.expand('~/.vim/undodir')

    -- Status Line
    vim.opt.showmode = false             -- Don't show mode (lualine does this)

    -- Easy window navigation
    vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
    vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
    vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
    vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

    -- Quick save
    vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })

    -- Clear search highlighting
    vim.keymap.set('n', '<leader>h', ':noh<CR>', { noremap = true, silent = true })

    -- Buffer navigation
    vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { noremap = true, silent = true })

    -- ========================================
    -- Plugin Configurations
    -- ========================================

    -- Dracula Theme
    vim.cmd[[colorscheme dracula]]

    -- Transparent
    require('transparent')


    -- Treesitter
    require('nvim-treesitter.configs').setup({
      highlight = {
        enable = true,              -- Enable syntax highlighting
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true               -- Enable treesitter-based indentation
      },
    })

    -- Autopairs
    require('nvim-autopairs').setup({
      check_ts = true,              -- Enable treesitter integration
      ts_config = {
        lua = {'string'},           -- Don't add pairs in lua string treesitter nodes
        javascript = {'template_string'},
      }
    })

    -- Comment
    require('nvim_comment').setup({
      comment_empty = false,        -- Don't comment empty lines
    })

    -- Gitsigns
    require('gitsigns').setup({
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
    })

    -- Lualine
    require('lualine').setup({
      options = {
        theme = 'dracula',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = ''', right = '''},
      },
    })

    -- Telescope keybindings
    local telescope = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Find buffers' })
    vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Help tags' })

    -- Which-key
    require('which-key').setup({
      plugins = {
        spelling = { enabled = true },
      },
    })

    -- Neoscroll (smooth scrolling)
    require('neoscroll').setup({})

    -- LSP Configuration (Neovim 0.11+ built-in)
    -- Use vim.lsp.config('...') to customize before enabling
    vim.lsp.enable('basedpyright')      -- Python
    vim.lsp.enable('lua_ls')       -- Lua
    vim.lsp.enable('ts_ls')        -- TypeScript/JavaScript
    vim.lsp.enable('nixd')
    -- vim.lsp.enable('nil_ls')    -- Nix

    -- Claude Code
    require('claude-code').setup()
    vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
  '';
}
