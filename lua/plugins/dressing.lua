return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      enabled = true,
      default_prompt = "Input:",
      prompt_align = "left",
      insert_only = true,
      start_in_insert = true,
      border = "rounded",
      relative = "cursor",
    },
    select = {
      enabled = true,
      backend = { "telescope", "fzf", "builtin" },
      trim_prompt = true,
    },
  },
}