return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = {
      formatters_by_ft = {
        -- Lua formatting
        lua = { "stylua" },
        -- JavaScript/TypeScript ecosystem
        javascript = { "prettier", "eslint" },
        typescript = { "prettier", "eslint" },
        javascriptreact = { "prettier", "eslint" },
        typescriptreact = { "prettier", "eslint" },
        -- Python
        python = { "black", "isort" },
        -- Markup and config
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        -- Shell scripts
        sh = { "shfmt" },
      },
      -- Formatter-specific settings
      formatters = {
        stylua = {
          prepend_args = {
            "--column-width=120",
            "--indent-type=Spaces",
            "--indent-width=2",
          },
        },
        prettier = {
          prepend_args = {
            "--print-width=100",
            "--tab-width=2",
            "--single-quote",
            "--trailing-comma=es5",
          },
        },
        black = {
          prepend_args = {
            "--line-length=120",
            "--skip-string-normalization",
          },
        },
        shfmt = {
          prepend_args = {
            "-i",
            "2", -- indent with 2 spaces
            "-bn", -- binary ops like && and | may start a line
            "-ci", -- switch cases will be indented
          },
        },
        eslint = {
          prepend_args = {
            "--config",
            ".eslintrc.js",
          },
        },
      },
    },
  },
}
