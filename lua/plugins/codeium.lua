return {

  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    opts = {
      show_label = false,
      max_lines = 1,
    },
    config = function()
      local neocodeium = require("neocodeium")
      neocodeium.setup()

      -- Smart tab mapping that checks for completion availability
      vim.keymap.set("i", "<tab>", function()
        if neocodeium.visible() then
          return neocodeium.accept()
        else
          return "<tab>"
        end
      end, { expr = true })

      vim.keymap.set("i", "<A-w>", neocodeium.accept_word)
      vim.keymap.set("i", "<A-a>", neocodeium.accept_line)
      vim.keymap.set("i", "<A-e>", neocodeium.cycle_or_complete)
      vim.keymap.set("i", "<A-r>", function()
        neocodeium.cycle_or_complete(-1)
      end)
      vim.keymap.set("i", "<A-c>", neocodeium.clear)
    end,
  },
}
