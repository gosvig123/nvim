-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.guifont = "monospace:h22"
vim.g.snacks_animate = false
vim.opt.showmode = false
vim.opt.laststatus = 0
vim.opt.showtabline = 0
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "blue", fg = "white" })
vim.opt.cmdheight = 0
local opt = vim.opt
opt.shiftwidth = 2 -- Set indent width to 2 spaces
opt.expandtab = true -- Use spaces instead of tabs
opt.autoindent = true -- Enable auto-indenting
opt.smartindent = true -- Enable smart indenting
vim.opt.updatetime = 100  -- Faster completion
vim.opt.timeoutlen = 300  -- Faster key sequence completion
vim.opt.scrolloff = 8     -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard
vim.opt.undofile = true   -- Persistent undo
vim.opt.pumheight = 10    -- Maximum number of items in completion menu

