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
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.g.lazyvim_eslint_auto_format = true
-- Make the cursor more visible
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50"
-- add spell check
vim.opt.spell = true
vim.opt.spelllang = "en"
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

-- Python LSP configuration
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_formatter = "black"
vim.g.lazyvim_python_linter = "ruff"
vim.g.lazyvim_python_mypy = "mypy"

-- Python virtual environment handling
vim.g.python3_host_prog = vim.fn.expand("$CONDA_PREFIX/bin/python3")

-- Automatically detect and use virtual environment
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Check for conda environment
    local conda_prefix = vim.fn.environ()["CONDA_PREFIX"]
    if conda_prefix then
      vim.g.python3_host_prog = conda_prefix .. "/bin/python3"
    else
      -- Check for other virtual environments
      local venv_path = vim.fn.finddir("venv", vim.fn.getcwd() .. ";")
      local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info -p"))

      if venv_path ~= "" then
        vim.g.python3_host_prog = vim.fn.getcwd() .. "/" .. venv_path .. "/bin/python3"
      elseif poetry_venv ~= "" and poetry_venv:match("^/") then
        vim.g.python3_host_prog = poetry_venv .. "/bin/python3"
      end
    end
  end,
})

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
    source = true,
    severity = {
      min = vim.diagnostic.severity.HINT,
    },
  },
  float = {
    source = true,
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

vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.timeoutlen = 300
-- manage undo files
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
