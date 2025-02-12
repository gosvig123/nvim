-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
local function organise_imports()
  -- Add missing imports
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.addMissingImports" },
      diagnostics = {},
    },
  })
  -- Remove unused imports
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.removeUnused.ts" },
      diagnostics = {},
    },
  })
end
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("organise_imports", { clear = true }),
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = organise_imports,
})
