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
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
          layout = "float",
          border = "rounded",
          row = 0, -- Position at the top
          col = vim.o.columns - math.floor(vim.o.columns * 0.4), -- Position at the right
        },
      }
    end,
  },
}
