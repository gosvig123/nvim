return {
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      dir_path = vim.fn.stdpath("data") .. "/devdocs",
      telescope = {},
      float_win = {
        relative = "editor",
        height = 25,
        width = 100,
        border = "rounded",
      },
      wrap = false,
      previewer_cmd = vim.fn.executable("glow") == 1 and "glow" or nil,
      cmd_args = { "-s", "dark", "-w", "80" },
      cmd_ignore = {},
      picker_cmd = true,
      picker_cmd_args = { "-s", "dark", "-w", "50" },
      mappings = {
        open_in_browser = "gx",
      },
      ensure_installed = {},
      after_open = function(bufnr) end,
    },
  },
}
