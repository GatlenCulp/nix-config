-- Core editor cluster, ported from nvix (nixvim):
--   plugins/common/ (colorscheme.nix, plugins.nix), plugins/ux.nix, plugins/buffer.nix
-- Pure-vim options/keymaps/autocmds from common/ live in lua/config/;
-- only plugin-owned keymaps are defined here.

return {
  -- common/colorscheme.nix: dracula.nvim lives in lua/plugins/colorscheme.lua
  -- (single owner: priority 1000 + the vim.cmd.colorscheme call).

  -- common/plugins.nix: plugins.comment
  {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {
      toggler = { line = "<leader>/" },
      opleader = { line = "<leader>/" },
    },
  },

  -- common/plugins.nix: plugins.tmux-navigator
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    init = function()
      -- In nvix the smart-splits keymaps (below) were applied after plugin
      -- load and overrode all five default tmux-navigator maps
      -- (<C-h/j/k/l/\>). Disable them so smart-splits (which has its own
      -- tmux multiplexer support) deterministically owns those keys.
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  -- common/plugins.nix: plugins.smart-splits (+ keymaps from common/mappings.nix)
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      -- stylua: ignore start
      { "<c-a-h>", function() require("smart-splits").resize_left() end, desc = "Resize Left", silent = true },
      { "<c-a-j>", function() require("smart-splits").resize_down() end, desc = "Resize Down", silent = true },
      { "<c-a-k>", function() require("smart-splits").resize_up() end, desc = "Resize Up", silent = true },
      { "<c-a-l>", function() require("smart-splits").resize_right() end, desc = "Resize Right", silent = true },
      { "<c-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move Cursor Left", silent = true },
      { "<c-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move Cursor Down", silent = true },
      { "<c-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move Cursor Up", silent = true },
      { "<c-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move Cursor Right", silent = true },
      { "<c-\\>", function() require("smart-splits").move_cursor_previous() end, desc = "Move Cursor Previous", silent = true },
      -- stylua: ignore end
    },
  },

  -- common/plugins.nix: plugins.web-devicons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- common/plugins.nix: plugins.nvim-surround (lazyLoad disabled upstream)
  { "kylechui/nvim-surround", lazy = false, opts = {} },

  -- common/plugins.nix: plugins.nvim-autopairs
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- common/plugins.nix: plugins.trim (+ <leader>ut keymap from mappings.nix)
  {
    "cappyzawa/trim.nvim",
    lazy = false,
    opts = {},
    keys = {
      { "<leader>ut", ":TrimToggle<cr>", desc = "Toggle Trim", silent = true },
    },
  },

  -- common/plugins.nix: plugins.flash (+ keymaps from mappings.nix/plugins.nix)
  {
    "folke/flash.nvim",
    event = "VeryLazy", -- char mode (f/F/t/T) needs the plugin loaded
    opts = {
      modes = {
        char = { enabled = true, jump_labels = true },
      },
    },
    keys = {
      {
        "?",
        function()
          require("flash").jump({ forward = true, wrap = true, multi_window = true })
        end,
        mode = "n",
        desc = "Flash Search",
        silent = true,
      },
      {
        "<leader>vt",
        function()
          require("flash").treesitter()
        end,
        mode = "n",
        desc = "Select Treesitter Node",
        silent = true,
      },
    },
  },

  -- common/plugins.nix: plugins.visual-multi
  { "mg979/vim-visual-multi", lazy = false },

  -- common/plugins.nix: plugins.which-key (spec = wKeyList entries owned by
  -- this cluster: common/mappings.nix + buffer.nix; other clusters register
  -- their own group icons via wk.add() or additional which-key specs)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      -- nixvim declared these at the settings top level; which-key v3 keeps
      -- the built-in preset toggles under plugins.presets.
      plugins = {
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      spec = {
        { "<leader>A", icon = "", group = "", hidden = true },
        { "<leader><leader>", icon = "", group = "", hidden = true },
        { "<leader>q", icon = "", group = "quit/session" },
        { "<leader>i", icon = "", group = "Insert" },
        { "<leader>v", icon = "󰩬", group = "Insert" },
        { "z", icon = "", group = "fold" },
        { "g", icon = "", group = "goto" },
        { "[", icon = "", group = "next" },
        { "]", icon = "", group = "prev" },
        { "<leader>u", icon = "󰔎", group = "ui" },
        { "<leader>o", icon = "", group = "Open" },
        { "<leader>d", icon = "", group = "diff" },
        { "<leader>|", icon = "", group = "vsplit" },
        { "<leader>-", icon = "", group = "split" },
        { "<leader>c", icon = "󰁨", group = "quickfix" },
        { "<leader>b", icon = "", group = "buffers" },
        { "<leader><tab>", icon = "", group = "tabs" },
      },
    },
  },

  -- common/plugins.nix: extraPlugins stay-centered-nvim (nvix never called
  -- setup(); only the toggle keymap from mappings.nix references it)
  {
    "arnamak/stay-centered.nvim",
    keys = {
      {
        "<leader>uC",
        function()
          require("stay-centered").toggle()
        end,
        desc = "Toggle stay-centered.nvim",
        silent = true,
      },
    },
  },

  -- ux.nix: extraPlugins windows-nvim + extraConfigLua (verbatim)
  {
    "anuvyklack/windows.nvim",
    lazy = false,
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10 -- overrides winminwidth=5 from common options
      vim.o.equalalways = false
      require("windows").setup({
        ignore = {
          filetype = { "snacks_picker_list", "snacks_layout_box" },
        },
      })
    end,
  },

  -- ux.nix: plugins.colorizer
  {
    "catgoose/nvim-colorizer.lua",
    lazy = false,
    opts = {
      filetypes = { "*" },
      user_default_options = {
        names = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        tailwind = true,
        mode = "virtualtext",
        virtualtext = "■",
        always_update = true,
      },
    },
  },

  -- ux.nix: plugins.dressing
  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {
      input = {
        mappings = {
          n = {
            q = "Close",
            k = "HistoryPrev",
            j = "HistoryNext",
          },
        },
      },
    },
  },

  -- ux.nix: plugins.lastplace
  { "ethanholz/nvim-lastplace", lazy = false, opts = {} },

  -- ux.nix: plugins.fidget
  {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {
      progress = {
        display = { progress_icon = { "moon" } },
      },
      notification = {
        window = {
          relative = "editor",
          winblend = 0,
          border = "none",
        },
      },
    },
  },

  -- buffer.nix: plugins.harpoon (harpoon2 API: harpoon:list())
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
    keys = {
      {
        "<leader>b.",
        function()
          local harpoon = require("harpoon")
          harpoon:list():add()
        end,
        desc = "Add File to Harpoon",
        silent = true,
      },
      {
        "<leader>bb",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon ui",
        silent = true,
      },
    },
  },

  -- buffer.nix: plugins.bufferline (+ buffer/tab keymaps from buffer.nix)
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        buffer_close_icon = "󰅙",
        close_icon = "󰅙",
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>bp", "<cmd>:BufferLinePick<cr>", desc = "Buffer Line Pick", silent = true },
      { "<leader>qc", "<cmd>:bp | bd #<cr>", desc = "Buffer close", silent = true },
      { "<leader>bP", "<cmd>BufferLineTogglePin<cr>", desc = "Buffer Pin", silent = true },
      { "<leader>bd", "<cmd>BufferLineSortByDirectory<cr>", desc = "Buffer Sort by dir", silent = true },
      { "<leader>be", "<cmd>BufferLineSortByExtension<cr>", desc = "Buffer Sort by ext", silent = true },
      { "<leader>bt", "<cmd>BufferLineSortByTabs<cr>", desc = "Buffer Sort by Tabs", silent = true },
      { "<leader>bL", "<cmd>BufferLineCloseRight<cr>", desc = "Buffer close all to right", silent = true },
      { "<leader>bH", "<cmd>BufferLineCloseLeft<cr>", desc = "Buffer close all to left", silent = true },
      -- source said :BufferLineCloseOther (no trailing s), which is not a real
      -- command; fixed to the actual bufferline command.
      { "<leader>bc", "<cmd>BufferLineCloseOthers<cr>", desc = "Buffer close all except the current buffer", silent = true },
      { "<a-s-h>", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer to left", silent = true },
      { "<a-s-l>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer to right", silent = true },
      { "<s-h>", ":BufferLineCyclePrev<cr>", desc = "Buffer Previous", silent = true },
      { "<s-l>", ":BufferLineCycleNext<cr>", desc = "Buffer Next", silent = true },
      -- plain tab management maps declared alongside bufferline in buffer.nix
      { "<leader><tab>j", "<cmd>tabn<cr>", desc = "Next Tab", silent = true },
      { "<leader><tab>k", "<cmd>tabp<cr>", desc = "Previous Tab", silent = true },
      { "<leader><tab>l", "<cmd>tabn<cr>", desc = "Next Tab", silent = true },
      { "<leader><tab>h", "<cmd>tabp<cr>", desc = "Previous Tab", silent = true },
      { "<leader>qt", "<cmd>tabclose<cr>", desc = "Close Tab", silent = true },
      { "<leader><tab>q", "<cmd>tabclose<cr>", desc = "Close Tab", silent = true },
      { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New Tab", silent = true },
    },
  },
}
