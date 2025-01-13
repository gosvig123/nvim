return {
  "atiladefreitas/lazyclip",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("lazyclip").setup()
  end,
  keys = {
    { "<leader>oc", "<cmd>LazyClip<cr>", desc = "Open Clipboard Manager" },
  },
  -- Optional: Load plugin when yanking text
  event = { "TextYankPost" },
}

