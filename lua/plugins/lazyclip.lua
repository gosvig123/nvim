return {
  "atiladefreitas/lazyclip",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("lazyclip").setup({
      -- Core settings
      max_history = 100,      -- Maximum items in history
      items_per_page = 9,     -- Items shown per page
      min_chars = 5,          -- Minimum characters to store

      -- Window appearance
      window = {
        relative = "editor",
        width = 70,
        height = 12,
        border = "rounded",
      },

      -- Internal keymaps
      keymaps = {
        close_window = "q",
        prev_page = "h",
        next_page = "l",
        paste_selected = "<CR>",
        move_up = "k",
        move_down = "j",
        delete_item = "d"
      }
    })
  end,
  keys = {
    { "<leader>Cw", desc = "Open Clipboard Manager" },
  },
  event = { "TextYankPost" },
}