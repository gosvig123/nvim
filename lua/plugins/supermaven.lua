return {
  "supermaven-inc/supermaven-nvim",
  event = "VeryLazy",
  config = function()
    vim.notify("Setting up supermaven-nvim")
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { cpp = true }, -- or { "cpp", }
      color = {
        -- add a green color
        suggestion_color = "#FFFF00",
        cterm = 244,
      },
      log_level = "info", -- set to "off" to disable logging completely
      disable_inline_completion = false, -- disables inline completion for use with cmp
      disable_keymaps = false, -- disables built in keymaps for more manual control
      condition = function()
        return false
      end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
    })
    vim.cmd([[
      highlight SuperMavenSuggestion guifg=#00FF00 guibg=#000000
      highlight SuperMavenSuggestionText guifg=#00FF00 guibg=#000000
    ]])
    vim.notify("Supermaven-nvim setup complete")
  end,
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
}
