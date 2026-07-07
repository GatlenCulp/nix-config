-- Ported from nvix plugins/snacks/ (default.nix + mappings.nix).
-- Includes todo-comments and neoscroll, which were enabled from the same module.

-- Shared picker window keys (input + list), ported from snacks/default.nix
local picker_keys = {
  ["<c-d>"] = { "preview_scroll_down", mode = "n" },
  ["<c-u>"] = { "preview_scroll_up", mode = "n" },
  ["-"] = { "edit_split", mode = "n" },
  ["|"] = { "edit_vsplit", mode = "n" },
  ["<cr>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
}

return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      scroll = { enabled = false }, -- neoscroll is used instead
      lazygit = {
        config = {
          os = {
            edit = '[ -z ""$NVIM"" ] && (nvim -- {{filename}}) || (nvim --server ""$NVIM"" --remote-send ""q"" && nvim --server ""$NVIM"" --remote {{filename}})',
          },
        },
      },
      quickfile = { enabled = true },
      indent = { enabled = true },
      words = { enabled = true },
      statuscolumn = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          {
            pane = 2,
            section = "terminal",
            cmd = "colorscript -e square",
            height = 5,
            padding = 1,
          },
          { section = "keys", gap = 1, padding = 1 },
          {
            pane = 2,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                title = "Notifications",
                cmd = "PAGER= gh notify -s -a -n5",
                action = function()
                  vim.ui.open("https://github.com/notifications")
                end,
                key = "n",
                icon = " ",
                height = 5,
                enabled = true,
              },
              {
                title = "Open Issues",
                cmd = "PAGER= gh issue list -L 3",
                key = "i",
                action = function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end,
                icon = " ",
                height = 7,
              },
              {
                icon = " ",
                title = "Open PRs",
                cmd = "PAGER= gh pr list -L 3",
                key = "P",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 7,
              },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
          -- { section = "startup" },
        },
      },
      picker = {
        enabled = true,
        actions = {
          -- FIXME (from nvix): on non overridden theme the picker window opens buffer with bg
          pick_win = function(picker)
            if not picker.layout.split then
              picker.layout:hide()
            end
            local win = Snacks.picker.util.pick_win({
              main = picker.main,
              float = false,
              filter = function(_, buf)
                local ft = vim.bo[buf].ft
                return ft == "snacks_dashboard" or not ft:find("^snacks")
              end,
            })
            if not win then
              if not picker.layout.split then
                picker.layout:unhide()
              end
              return true
            end
            picker.main = win
            if not picker.layout.split then
              vim.defer_fn(function()
                if not picker.closed then
                  picker.layout:unhide()
                end
              end, 100)
            end
          end,
        },
        sources = {
          explorer = {
            on_show = function(picker)
              local show = false
              local gap = 1
              local clamp_width = function(value)
                return math.max(20, math.min(100, value))
              end
              --
              local position = picker.resolved_layout.layout.position
              local rel = picker.layout.root
              local update = function(win) ---@param win snacks.win
                local border = win:border_size().left + win:border_size().right
                win.opts.row = vim.api.nvim_win_get_position(rel.win)[1]
                win.opts.height = 0.8
                if position == "left" then
                  win.opts.col = vim.api.nvim_win_get_width(rel.win) + gap
                  win.opts.width = clamp_width(vim.o.columns - border - win.opts.col)
                end
                if position == "right" then
                  win.opts.col = -vim.api.nvim_win_get_width(rel.win) - gap
                  win.opts.width = clamp_width(vim.o.columns - border + win.opts.col)
                end
                win:update()
              end
              local preview_win = Snacks.win.new({
                relative = "editor",
                external = false,
                focusable = false,
                border = "rounded",
                backdrop = false,
                show = show,
                bo = {
                  filetype = "snacks_float_preview",
                  buftype = "nofile",
                  buflisted = false,
                  swapfile = false,
                  undofile = false,
                },
                on_win = function(win)
                  update(win)
                  picker:show_preview()
                end,
              })
              rel:on("WinLeave", function()
                vim.schedule(function()
                  if not picker:is_focused() then
                    picker.preview.win:close()
                  end
                end)
              end)
              rel:on("WinResized", function()
                update(preview_win)
              end)
              picker.preview.win = preview_win
              picker.main = preview_win.win
            end,
            on_close = function(picker)
              picker.preview.win:close()
            end,
            layout = {
              preset = "sidebar",
              layout = {
                backdrop = false,
                width = 40, -- Pfff.. 40. I have 60!
                min_width = 40,
                height = 0,
                position = "right",
                border = "none",
                box = "vertical",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", height = 0.4, border = "top" },
              },
              preview = false, ---@diagnostic disable-line
            },
            actions = {
              toggle_preview = function(picker) --[[Override]]
                picker.preview.win:toggle()
              end,
            },
          },
        },
        win = {
          input = { keys = picker_keys },
          list = { keys = picker_keys },
        },
      },
      image = {
        enabled = true,
        border = "none",
        doc = { inline = false },
      },
      notifier = {
        enabled = true,
        style = "minimal",
        top_down = false,
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Ported from nvix autoCmd (VimEnter, "Pre init Function")
      -- Taken from https://github.com/folke/snacks.nvim?tab=readme-ov-file#-usage
      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Pre init Function",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        end,
      })
    end,
    -- Keymaps ported from snacks/mappings.nix (duplicates deduped; where the nix
    -- list mapped a key twice, the last definition won and is the one kept here).
    keys = {
      { "<leader>e", "<cmd>:lua Snacks.explorer()<cr>", desc = "Explorer", silent = true },
      { "<leader>..", "<cmd>:lua Snacks.scratch()<cr>", desc = "Toggle Scratch Buffer", silent = true },
      { "<leader>.s", "<cmd>:lua Snacks.scratch.select()<cr>", desc = "Select Scratch Buffer", silent = true },
      {
        "<leader>sn",
        "<cmd>:lua Snacks.notifier.show_history()<cr>",
        desc = "Notification History",
        silent = true,
      },
      {
        "<leader>.r",
        "<cmd>:lua Snacks.rename.rename_file()<cr>",
        desc = "Rename file/variable +lsp",
        silent = true,
      },
      { "<leader>gB", "<cmd>:lua Snacks.gitbrowse()<cr>", desc = "Git Browse", silent = true },
      {
        "<leader>gf",
        "<cmd>:lua Snacks.lazygit.log_file()<cr>",
        desc = "Lazygit Current File History",
        silent = true,
      },
      { "<leader>gg", "<cmd>:lua Snacks.lazygit()<cr>", desc = "Lazygit", silent = true },
      { "<leader>gl", "<cmd>:lua Snacks.lazygit.log()<cr>", desc = "Lazygit Log (cwd)", silent = true },
      { "<leader>gL", "<cmd>:lua Snacks.picker.git_log()<cr>", desc = "Git Log (cwd)", silent = true },
      { "<leader>un", "<cmd>:lua Snacks.notifier.hide()<cr>", desc = "Dismiss All Notifications", silent = true },

      { "<leader>sb", "<cmd>:lua Snacks.picker.lines() <cr>", desc = "Buffer Lines", silent = true },
      { "<leader>sB", "<cmd>:lua Snacks.picker.grep_buffers() <cr>", desc = "Grep Open Buffers", silent = true },
      { "<leader>sg", "<cmd>:lua Snacks.picker.grep() <cr>", desc = "Grep", silent = true },
      {
        "<leader>sw",
        "<cmd>:lua Snacks.picker.grep_word() <cr>",
        desc = "Visual selection or word",
        mode = { "n", "x" },
        silent = true,
      },
      { '<leader>s"', "<cmd>:lua Snacks.picker.registers() <cr>", desc = "Registers", silent = true },
      { "<leader>sa", "<cmd>:lua Snacks.picker.autocmds() <cr>", desc = "Autocmds", silent = true },
      { "<leader>sc", "<cmd>:lua Snacks.picker.command_history() <cr>", desc = "Command History", silent = true },
      { "<leader>sC", "<cmd>:lua Snacks.picker.commands() <cr>", desc = "Commands", silent = true },
      { "<leader>sd", "<cmd>:lua Snacks.picker.diagnostics() <cr>", desc = "Diagnostics", silent = true },
      {
        "<leader>sD",
        "<cmd>:lua Snacks.picker.diagnostics_buffer() <cr>",
        desc = "Buffer Diagnostics",
        silent = true,
      },
      { "<leader>sH", "<cmd>:lua Snacks.picker.highlights() <cr>", desc = "Highlights", silent = true },
      { "<leader>si", "<cmd>:lua Snacks.picker.icons() <cr>", desc = "Icons", silent = true },
      { "<leader>sj", "<cmd>:lua Snacks.picker.jumps() <cr>", desc = "Jumps", silent = true },
      { "<leader>sl", "<cmd>:lua Snacks.picker.loclist() <cr>", desc = "Location List", silent = true },
      { "<leader>sm", "<cmd>:lua Snacks.picker.marks() <cr>", desc = "Marks", silent = true },
      { "<leader>sM", "<cmd>:lua Snacks.picker.man() <cr>", desc = "Man Pages", silent = true },
      { "<leader>sq", "<cmd>:lua Snacks.picker.qflist() <cr>", desc = "Quickfix List", silent = true },
      { "<leader>sR", "<cmd>:lua Snacks.picker.resume() <cr>", desc = "Resume", silent = true },

      { "gd", "<cmd>:lua Snacks.picker.lsp_definitions() <cr>", desc = "Goto Definition", silent = true },
      { "gD", "<cmd>:lua Snacks.picker.lsp_declarations() <cr>", desc = "Goto Declaration", silent = true },
      { "gr", "<cmd>:lua Snacks.picker.lsp_references() <cr>", desc = "References", silent = true },
      { "gI", "<cmd>:lua Snacks.picker.lsp_implementations() <cr>", desc = "Goto Implementation", silent = true },
      {
        "gy",
        "<cmd>:lua Snacks.picker.lsp_type_definitions() <cr>",
        desc = "Goto T[y]pe Definition",
        silent = true,
      },
      {
        "<leader>sS",
        "<cmd>:lua Snacks.picker.lsp_workspace_symbols() <cr>",
        desc = "LSP Workspace Symbols",
        silent = true,
      },

      -- Telescope replacement
      { "<leader>sP", "<cmd>:lua Snacks.picker()<cr>", desc = "Pickers", silent = true },
      -- NOTE: <leader>ss was first mapped to lsp_symbols, then overridden by smart in the nix list
      { "<leader>ss", "<cmd>:lua Snacks.picker.smart()<cr>", desc = "Smart", silent = true },
      {
        "<leader>st",
        "<cmd>:lua Snacks.picker.todo_comments({layout = 'ivy'})<cr>",
        desc = "Todo",
        silent = true,
      },
      {
        "<leader>sT",
        [[<cmd>:lua Snacks.picker.todo_comments({keywords = {"TODO", "FIX", "FIXME"}, layout = 'ivy'})<cr>]],
        desc = "Todo",
        silent = true,
      },
      {
        "<leader>s:",
        "<cmd>:lua Snacks.picker.command_history({ layout = 'ivy'})<cr>",
        desc = "Command History",
        silent = true,
      },
      { "<leader>s,", "<cmd>:lua Snacks.picker.buffers({layout = 'ivy'})<cr>", desc = "Buffers", silent = true },
      { "<leader>sh", "<cmd>:lua Snacks.picker.help()<cr>", desc = "Help Pages", silent = true },
      {
        "<leader>sk",
        "<cmd>:lua Snacks.picker.keymaps({layout = 'vscode'})<cr>",
        desc = "Keymaps",
        silent = true,
      },

      -- NOTE: <leader>su was first mapped to plain picker.undo ("Undo History"),
      -- then overridden by this function in the nix list
      {
        "<leader>su",
        function()
          Snacks.picker.undo({
            win = {
              input = {
                keys = {
                  ["y"] = { "yank_add", mode = "n" },
                  ["Y"] = { "yank_del", mode = "n" },
                },
              },
            },
          })
        end,
        desc = "Undo",
        silent = true,
      },

      { "<leader>ff", "<cmd>:lua Snacks.picker.files()<cr>", desc = "Find Files", silent = true },
      { "<leader>fF", "<cmd>:lua Snacks.picker.smart()<cr>", desc = "Smart", silent = true },
      { "<leader>f/", "<cmd>:lua Snacks.picker.grep()<cr>", desc = "Grep", silent = true },
      {
        "<leader>f?",
        "<cmd>:lua Snacks.picker.grep({layout = 'ivy', args = { '--vimgrep', '--smart-case', '--fixed-strings' } })<cr>",
        desc = "Grep",
        silent = true,
      },
      { "<leader>fr", "<cmd>:lua Snacks.picker.recent()<cr>", desc = "Recent", silent = true },
      { "<leader>fp", "<cmd>:lua Snacks.picker.projects()<cr>", desc = "Projects", silent = true },
    },
  },

  -- which-key group labels from snacks/mappings.nix (wKeyList); merged into the
  -- which-key spec owned by another cluster, hence `optional`.
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>.", group = "Scratch Buffer", icon = "" },
        { "<leader>:", hidden = true },
        { "<leader>s", group = "search", icon = "" },
        { "<leader>f", group = "file/find", icon = "" },
        { "<leader>e", group = "Explorer", icon = "󰙅" },
      },
    },
  },

  -- plugins.todo-comments.enable = true (from snacks/default.nix)
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
  },

  -- plugins.neoscroll.enable = true (from snacks/default.nix)
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
