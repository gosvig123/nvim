return {
  "atiladefreitas/lazyclip",
  config = function()
    require("lazyclip").setup({
      -- your custom config here (optional)
    })
  end,
  keys = {
    { "<leader>Cw", "<cmd>LazyClip<cr>", desc = "Open Clipboard Manager" },
  },
  event = { "TextYankPost" },
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
}
