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

vim.api.nvim_set_keymap('n', '<leader>oa', '<cmd>lua AiderOpen()<cr>', {noremap = true, silent = true})

-- Keep track of the last position
local last_position = nil

-- Function to trim blank lines
local function trim_blank_line(line_num)
  -- Check if line_num is valid
  if line_num < 1 or line_num > vim.api.nvim_buf_line_count(0) then
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
  if line and line:match("^%s+$") then
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, {""})
  end
end

-- Function to check and trim previous position
local function check_and_trim_previous_position()
  if last_position then
    -- Ensure the buffer and line still exist
    local buf = vim.api.nvim_get_current_buf()
    local line_count = vim.api.nvim_buf_line_count(buf)

    if last_position[1] <= line_count then
      local line = vim.api.nvim_buf_get_lines(0, last_position[1] - 1, last_position[1], true)[1]
      if line and line:match("^%s*$") then
        trim_blank_line(last_position[1])
      end
    end
  end
end

-- Autocmd to track cursor movements
vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    -- Protect against invalid buffer states
    local ok, current_pos = pcall(vim.api.nvim_win_get_cursor, 0)
    if not ok then return end

    if last_position and current_pos[1] ~= last_position[1] then
      -- Protect against errors in the trim function
      pcall(check_and_trim_previous_position)
    end
    last_position = current_pos
  end
})

-- navigate to next blank line
vim.keymap.set("n", "}", function()
  -- Save the current position
  local start_pos = vim.api.nvim_win_get_cursor(0)
  local start_line = start_pos[1]

  -- Find the next blank line
  local found = false
  local line_num = start_line
  local last_line = vim.api.nvim_buf_line_count(0)

  while line_num <= last_line and not found do
    line_num = line_num + 1
    local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
    if line and line:match("^%s*$") then
      found = true
      break
    end
  end

  if found then
    -- Get indentation of the line above the blank line
    local prev_line = vim.api.nvim_buf_get_lines(0, line_num - 2, line_num - 1, true)[1]
    -- Find the position of the first non-whitespace character
    local indent_pos = prev_line:find("[^%s]") or 1
    local indent = string.rep(" ", indent_pos)

    -- Set the blank line's indentation to match
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, {indent})

    -- Move cursor to match the indentation of the previous line
    vim.api.nvim_win_set_cursor(0, {line_num, indent_pos })
  end
end)

-- navigate to previous blank line
vim.keymap.set("n", "{", function()
  -- Save the current position
  local start_pos = vim.api.nvim_win_get_cursor(0)
  local start_line = start_pos[1]

  -- Find the previous blank line
  local found = false
  local line_num = start_line

  while line_num > 1 and not found do
    line_num = line_num - 1
    local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
    if line and line:match("^%s*$") then
      found = true
      break
    end
  end

  if found then
    -- Get indentation of the line above the blank line
    local prev_line = vim.api.nvim_buf_get_lines(0, line_num - 2, line_num - 1, true)[1]
    -- Find the position of the first non-whitespace character
    local indent_pos = prev_line:find("[^%s]") or 1
    local indent = string.rep(" ", indent_pos )

    -- Set the blank line's indentation to match
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, {indent})

    -- Move cursor to match the indentation of the previous line
    vim.api.nvim_win_set_cursor(0, {line_num, indent_pos})
  end
end)
