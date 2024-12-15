return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "SmiteshP/nvim-navic",
      dependencies = {
        "neovim/nvim-lspconfig"
      }
    },
    opts = function()
      local navic = require("nvim-navic")

      -- Setup navic
      navic.setup({
        lsp = {
          auto_attach = true,
          preference = nil
        },
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true
      })

      return {
        winbar = {
          lualine_a = { "mode" },
          lualine_b = {
            { "filename", path = 1 }, -- 'path = 1' shows relative path
            { navic.get_location, cond = navic.is_available },
          },
          lualine_c = {},
          lualine_x = { "filetype" },  -- Simplified right side
          lualine_y = {},
          lualine_z = {},
        },
        sections = {}, -- Empty sections to remove bottom bar
        inactive_sections = {}, -- Empty inactive sections as well
      }
    end,
  }
}
