return {
  "folke/trouble.nvim",
  opts = {
    -- To configure the width, use opts.win.size. However, automatic content-based width
    -- might not be directly supported by this option. Further investigation may be needed.
    win = {
      size = { width = 80 }, -- Default width
      position = "right",
    },
  },
  keys = {
    { "<cr>", ":Trouble jump | vert new<cr>", desc = "Open in new vertical split" },
  },
}
