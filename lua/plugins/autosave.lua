return {
  {
    "pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        enabled = true,
        execution_message = {
          message = function()
            return "Autosaving..."
          end,
          cleaning_interval = 1,
        },
        trigger_events = { "InsertLeave", "TextChanged" },
        debounce_delay = 135,
      })
    end,
  },
}
