-- Ported from nvix plugins/git.nix (gitsigns.nvim + git-conflict.nvim).
-- Icons inlined from nvix config.nvix.icons.ui:
--   LineLeft = "▏", Triangle = "󰐊", BoldLineLeft = "▎"
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      preview_config = { border = "rounded" },
      signs = {
        add = { text = "▏" },
        change = { text = "▏" },
        delete = { text = "▏" },
        topdelete = { text = "󰐊" },
        changedelete = { text = "▎" },
      },
    },
    keys = {
      -- Navigation
      {
        "]h",
        function()
          if vim.wo.diff then
            -- source had "normal! ' ]c'" (leading space, likely a typo); fixed to "]c"
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end,
        desc = "Next Hunk",
        silent = true,
      },
      {
        "[h",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end,
        desc = "Prev Hunk",
        silent = true,
      },
      {
        "]H",
        function()
          require("gitsigns").nav_hunk("last")
        end,
        desc = "Last Hunk",
        silent = true,
      },
      {
        "[H",
        function()
          require("gitsigns").nav_hunk("first")
        end,
        desc = "First Hunk",
        silent = true,
      },

      -- Stage / Reset
      {
        "<leader>gs",
        function()
          require("gitsigns").stage_buffer()
        end,
        desc = "Stage Buffer",
        silent = true,
      },
      {
        "<leader>gs",
        function()
          require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end,
        mode = "v",
        desc = "Stage/Unstage Selection",
        silent = true,
      },
      {
        "<leader>gr",
        function()
          require("gitsigns").reset_buffer()
        end,
        desc = "Reset Buffer",
        silent = true,
      },
      {
        "<leader>gr",
        function()
          require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end,
        mode = "v",
        desc = "Reset Selection",
        silent = true,
      },

      -- Undo
      {
        "<leader>gu",
        function()
          require("gitsigns").undo_stage_hunk()
        end,
        desc = "Undo Stage Hunk",
        silent = true,
      },

      -- Preview / Diff
      {
        "<leader>gp",
        function()
          require("gitsigns").preview_hunk_inline()
        end,
        desc = "Preview Hunk Inline",
        silent = true,
      },
      {
        "<leader>gP",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Preview Hunk (Popup)",
        silent = true,
      },
      {
        "<leader>gp",
        function()
          require("gitsigns").preview_hunk_inline({ vim.fn.line("."), vim.fn.line("v") })
        end,
        mode = "v",
        desc = "Preview Selection",
        silent = true,
      },
      {
        "<leader>dg",
        function()
          require("gitsigns").diffthis()
        end,
        desc = "Git Diff ",
        silent = true,
      },
      {
        "<leader>dG",
        function()
          require("gitsigns").diffthis("~")
        end,
        desc = "Git diff last commit (HEAD~)",
        silent = true,
      },

      -- Blame
      {
        "<leader>gk",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Blame Line (Full)",
        silent = true,
      },
      {
        "<leader>gK",
        function()
          require("gitsigns").blame()
        end,
        desc = "Blame File",
        silent = true,
      },

      -- Quickfix
      {
        "<leader>gq",
        function()
          require("gitsigns").setqflist()
        end,
        desc = "Hunks to Quickfix",
        silent = true,
      },
      {
        "<leader>gQ",
        function()
          require("gitsigns").setqflist("all")
        end,
        desc = "All Hunks to Quickfix",
        silent = true,
      },

      -- Toggles
      {
        "<leader>gb",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle Blame (Line)",
        silent = true,
      },
      {
        "<leader>gw",
        function()
          require("gitsigns").toggle_word_diff()
        end,
        desc = "Toggle Word Diff",
        silent = true,
      },

      -- Text object
      { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Select Hunk", silent = true },
    },
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = { default_mappings = true },
  },

  -- which-key group labels (from nvix wKeyList); no-op if which-key is absent
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>g", group = "git", icon = "" },
        { "<leader>gh", group = "hunks", icon = "󰫅" },
        { "<leader>gb", group = "blame", icon = "󰭐" },
      })
    end,
  },
}
