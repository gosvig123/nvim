return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      matchup = {
        enable = true,
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
      autotag = { enable = true },
      context_commentstring = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          node_decremental = "<BS>",
          scope_incremental = "<TAB>",
        },
      },
      textobjects = {
        enable = true,
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    },
  },
}
