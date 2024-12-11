-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "el", function()
  local line = vim.api.nvim_get_current_line()
  local col = #line
  vim.api.nvim_win_set_cursor(0, {vim.fn.line("."), col})
end)

vim.keymap.set("n", "fl", function()
  local line = vim.api.nvim_get_current_line()
  local first_non_blank = line:match("^%s*()%S") or 1
  vim.api.nvim_win_set_cursor(0, {vim.fn.line("."), first_non_blank - 1})
end)


