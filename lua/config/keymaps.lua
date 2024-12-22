-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "el", function()
  local line = vim.api.nvim_get_current_line()
  local col = #line
  vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), col })
end)

vim.keymap.set("n", "fl", function()
  local line = vim.api.nvim_get_current_line()
  local first_non_blank = line:match("^%s*()%S") or 1
  vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), first_non_blank - 1 })
end)

vim.keymap.set("v", "fl", function()
  local line = vim.api.nvim_get_current_line()
  local first_non_blank = line:match("^%s*()%S") or 1
  vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), first_non_blank - 1 })
end)

vim.keymap.set("v", "el", function()
  local line = vim.api.nvim_get_current_line()
  local col = #line
  vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), col })
end)

vim.api.nvim_set_keymap("n", "<leader>oa", "<cmd>lua AiderOpen()<cr>", { noremap = true, silent = true })

-- Remap leader cs to leader oo
vim.keymap.set("n", "<leader>oo", function()
  require('telescope.builtin').lsp_document_symbols({
    layout_strategy = 'vertical',
    layout_config = {
      width = 0.45,
      height = 0.95,
      anchor = 'E',
      prompt_position = 'top',
      preview_cutoff = 0,
      mirror = true,
      preview_height = 0.7,
    },
    show_line = true,
    jump_type = 'never',
    symbols = {
      'Class',
      'Function',
      'Method',
      'Constructor',
      'Interface',
      'Module',
      'Variable',
    },
  })
end, { desc = "Document Symbols (right side)" })
