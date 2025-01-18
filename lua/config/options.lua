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
vim.opt.updatetime = 100 -- Faster completion
vim.opt.timeoutlen = 300 -- Faster key sequence completion
vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.undofile = true -- Persistent undo
vim.opt.pumheight = 10 -- Maximum number of items in completion menu
vim.opt.cursorline = true -- Highlight the current line
vim.opt.cursorlineopt = "both" -- Highlight both line and line number
vim.opt.cursorcolumn = true -- Add vertical highlight
-- if js then the margin is 100 else 120
local js = vim.bo.filetype == "javascript"
local ts = vim.bo.filetype == "typescript"
vim.opt.colorcolumn = js and "100" or ts and "100" or "120" -- Add a margin line
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.g.lazyvim_eslint_auto_format = true
-- Make the cursor more visible
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50"

-- Add a subtle cursor line background in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2d3149" }) -- Slightly different color in insert mode
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#232433" }) -- Back to normal color
  end,
})
-- Add this keybinding to your keymaps.lua
vim.keymap.set("n", "<leader>rs", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Add after your existing options
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
    source = "if_many",
    severity = {
      min = vim.diagnostic.severity.HINT,
    },
  },
  float = {
    source = "if_many",
    border = "rounded",
    header = "",
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Define diagnostic signs
local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
