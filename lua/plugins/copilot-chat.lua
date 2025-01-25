return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          layout = "float",
          relative = "editor",
          width = math.floor(vim.o.columns * 0.4),
          height = math.floor(vim.o.lines * 0.4),
          border = "rounded",
          row = 1,
          col = math.floor(vim.o.columns * 0.6),
        },
        close_on_exit = true,
      }
    end,
  },
}
