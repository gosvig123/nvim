return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
        highlight = "IndentBlanklineChar",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        injected_languages = true,
        highlight = "Function",
        priority = 500,
        char = "│",
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
        },
      },
    },
  },
}