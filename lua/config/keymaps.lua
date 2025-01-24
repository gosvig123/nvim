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
--
-- -- Remap leader cs to leader oo
-- vim.keymap.set("n", "<leader>oo", function()
--   require("telescope.builtin").lsp_document_symbols({
--     layout_strategy = "vertical",
--     layout_config = {
--       width = 0.45,
--       height = 0.95,
--       anchor = "E",
--       prompt_position = "top",
--       preview_cutoff = 0,
--       mirror = true,
--       preview_height = 0.7,
--     },
--     show_line = true,
--     jump_type = "never",
--     symbols = {
--       "Class",
--       "Function",
--       "Method",
--       "Constructor",
--       "Interface",
--       "Module",
--       "Variable",
--     },
--   })
-- end, { desc = "Document Symbols (right side)" })
--
-- -- Git operations (add these to your existing keymaps)
vim.keymap.set("n", "]h", function()
  if vim.wo.diff then
    return "]h"
  end
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Next Hunk" })

vim.keymap.set("n", "[h", function()
  if vim.wo.diff then
    return "[h"
  end
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Previous Hunk" })

-- Quick hunk actions
vim.keymap.set("n", "<leader>ghs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Stage Hunk" })

vim.keymap.set("n", "<leader>ghr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset Hunk" })

vim.keymap.set("v", "<leader>ghs", function()
  require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Stage Selected Hunks" })

-- Quick file actions
vim.keymap.set("n", "<leader>gS", function()
  require("gitsigns").stage_buffer()
end, { desc = "Stage Buffer" })

vim.keymap.set("n", "<leader>gR", function()
  require("gitsigns").reset_buffer()
end, { desc = "Reset Buffer" })

-- Preview hunk changes
vim.keymap.set("n", "<leader>ghp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview Hunk" })
