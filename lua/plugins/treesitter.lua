return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000,
      },
      indent_markers = {
        enable = true,
        inline_markers = true,
        markers = {
          list = "│",
          nested = "├",
          last = "└",
        },
      },
      ensure_installed = {
        "typescript",
        "tsx",
        "python",
        "javascript",
        "json",
        "yaml",
        "html",
        "css",
        "markdown",
        "bash",
        "lua",
      },
      autotag = {
        enable = true,
      },
    },
  },
}