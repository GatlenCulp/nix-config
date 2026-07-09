-- Ported from nvix plugins/ai/copilot.nix (claude-code.nvim, copilot.lua, ChatGPT.nvim).
-- API keys (OPENAI_API_KEY, ANTHROPIC_API_KEY, ...) are exported by the shell
-- environment; nothing is hardcoded here.
return {
  -- nvix: extraPlugins = [ pkgs.vimPlugins.claude-code-nvim ] + require("claude-code").setup()
  {
    "greggh/claude-code.nvim",
    lazy = false, -- nvix ran setup() at startup (registers commands + default keymaps)
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claude-code").setup()
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      filetypes = { markdown = true },
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
    },
    keys = {
      {
        "<leader>ac",
        function()
          if vim.g.copilot_status == nil then
            vim.g.copilot_status = "running"
          end
          if vim.g.copilot_status == "running" then
            vim.g.copilot_status = "stopped"
            vim.cmd("Copilot disable")
          else
            vim.g.copilot_status = "running"
            vim.cmd("Copilot enable")
          end
        end,
        desc = "Toggle Copilot",
        silent = true,
      },
    },
  },

  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "ChatGPT",
      "ChatGPTActAs",
      "ChatGPTEditWithInstruction",
      "ChatGPTRun",
      "ChatGPTCompleteCode",
    },
    opts = {
      -- reads OPENAI_API_KEY from the environment by default
      keymaps = {
        submit = "<C-Enter>",
        close = "<Esc>",
      },
    },
    keys = {
      { "<leader>aCc", "<cmd>ChatGPT<CR>", desc = "ChatGPT", silent = true },
      {
        "<leader>aCe",
        "<cmd>ChatGPTEditWithInstruction<CR>",
        mode = { "n", "v" },
        desc = "Edit with instruction",
        silent = true,
      },
      {
        "<leader>aCg",
        "<cmd>ChatGPTRun grammar_correction<CR>",
        mode = { "n", "v" },
        desc = "Grammar Correction",
        silent = true,
      },
      { "<leader>aCt", "<cmd>ChatGPTRun translate<CR>", mode = { "n", "v" }, desc = "Translate", silent = true },
      { "<leader>aCk", "<cmd>ChatGPTRun keywords<CR>", mode = { "n", "v" }, desc = "Keywords", silent = true },
      { "<leader>aCd", "<cmd>ChatGPTRun docstring<CR>", mode = { "n", "v" }, desc = "Docstring", silent = true },
      { "<leader>aCa", "<cmd>ChatGPTRun add_tests<CR>", mode = { "n", "v" }, desc = "Add Tests", silent = true },
      {
        "<leader>aCo",
        "<cmd>ChatGPTRun optimize_code<CR>",
        mode = { "n", "v" },
        desc = "Optimize Code",
        silent = true,
      },
      { "<leader>aCs", "<cmd>ChatGPTRun summarize<CR>", mode = { "n", "v" }, desc = "Summarize", silent = true },
      { "<leader>aCf", "<cmd>ChatGPTRun fix_bugs<CR>", mode = { "n", "v" }, desc = "Fix Bugs", silent = true },
      {
        "<leader>aCx",
        "<cmd>ChatGPTRun explain_code<CR>",
        mode = { "n", "v" },
        desc = "Explain Code",
        silent = true,
      },
      {
        "<leader>aCr",
        "<cmd>ChatGPTRun roxygen_edit<CR>",
        mode = { "n", "v" },
        desc = "Roxygen Edit",
        silent = true,
      },
      {
        "<leader>aCl",
        "<cmd>ChatGPTRun code_readability_analysis<CR>",
        mode = { "n", "v" },
        desc = "Code Readability Analysis",
        silent = true,
      },
    },
  },

  -- which-key group label (from nvix wKeyList); no-op if which-key is absent
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>a", group = "ai", icon = "󰚩" },
      })
    end,
  },
}
