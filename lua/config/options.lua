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
