return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = {
      format_on_save = {
        lsp_fallback = true,
      },

      formatters_by_ft = {
        -- Lua formatting
        lua = { "stylua" },
        -- JavaScript/TypeScript ecosystem
        javascript = { { "prettierd", "prettier_d_slim", "prettier", "eslint_d", "eslint" } },
        typescript = { { "prettierd", "prettier_d_slim", "prettier", "eslint_d", "eslint" } },
        javascriptreact = { { "prettierd", "prettier_d_slim", "prettier", "eslint_d", "eslint" } },
        typescriptreact = { { "prettierd", "prettier_d_slim", "prettier", "eslint_d", "eslint" } },
        -- Python
        python = { "black", "isort" },
        -- Markup and config
        json = { { "prettierd", "prettier_d_slim", "prettier" } },
        yaml = { { "prettierd", "prettier_d_slim", "prettier" } },
        markdown = { { "prettierd", "prettier_d_slim", "prettier" } },
        -- Shell scripts
        sh = { "shfmt" },
      },

      -- Formatter-specific settings (your existing settings as fallbacks)
      formatters = {
        prettier = {
          condition = function(ctx)
            local has_prettier_config = vim.fs.find({
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.yml',
              '.prettierrc.yaml',
              '.prettierrc.json5',
              '.prettierrc.js',
              'prettier.config.js',
              '.prettierrc.mjs',
              'prettier.config.mjs',
              '.prettierrc.cjs',
              'prettier.config.cjs',
            }, { upward = true, path = ctx.dirname })[1]

            if not has_prettier_config then
              return {
                prepend_args = {
                  "--print-width=120",
                  "--tab-width=2",
                  "--single-quote",
                  "--trailing-comma=es5",
                },
              }
            end
            return true
          end,
        },
        eslint = {
          condition = function(ctx)
            return vim.fs.find({
              '.eslintrc',
              '.eslintrc.js',
              '.eslintrc.cjs',
              '.eslintrc.yaml',
              '.eslintrc.yml',
              '.eslintrc.json',
            }, { upward = true, path = ctx.dirname })[1] ~= nil
          end,
        },
        -- Your other formatter configs remain unchanged
        stylua = {
          prepend_args = {
            "--column-width=120",
            "--indent-type=Spaces",
            "--indent-width=2",
          },
        },
        black = {
          prepend_args = {
            "--line-length=100",
            "--skip-string-normalization",
          },
        },
        shfmt = {
          prepend_args = {
            "-i",
            "2",
            "-bn",
            "-ci",
          },
        },
      },
    },
  },
}

