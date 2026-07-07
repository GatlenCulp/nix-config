-- Ported from nvix plugins/autosession.nix (plugins.auto-session)
return {
  {
    "rmagatti/auto-session",
    lazy = false, -- autoLoad = true in nixvim; must load at startup to auto-restore
    opts = {
      use_git_branch = true,
      session_lens = { previewer = true },
    },
    -- stylua: ignore
    keys = {
      { "<leader>q.", "<cmd>SessionRestore<CR>", desc = "Last Session", silent = true },
      { "<leader>ql", "<cmd>Autosession search<CR>", desc = "List Session", silent = true },
      { "<leader>qd", "<cmd>Autosession delete<CR>", desc = "Delete Session", silent = true },
      { "<leader>qs", "<cmd>SessionSave<CR>", desc = "Save Session", silent = true },
      { "<leader>qD", "<cmd>SessionPurgeOrphaned<CR>", desc = "Purge Orphaned Sessions", silent = true },
    },
  },
}
