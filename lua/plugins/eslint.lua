return {
  -- Configure eslint
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
            format = true,
          },
        },
      },
      setup = {
        eslint = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              if require("lspconfig.util").get_active_client_by_name(event.buf, "eslint") then
                vim.cmd("EslintFixAll")
              end
            end,
          })
        end,
      },
    },
  },
  -- Configure null-ls integration
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, require("null-ls").builtins.diagnostics.eslint)
    end,
  },
}
