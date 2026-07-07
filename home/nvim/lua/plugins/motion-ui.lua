-- Ported from nvix plugins/precognition.nix and plugins/smear-cursor.nix
return {
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
