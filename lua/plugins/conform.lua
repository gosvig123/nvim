return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { { "eslint", "prettier" } },
      typescript = { { "eslint", "prettier" } },
      javascriptreact = { { "eslint", "prettier" } },
      typescriptreact = { { "eslint", "prettier" } },
    },
    formatters = {
      eslint = {
        command = "eslint_d",
        args = {
          "--fix",
          "--stdin",
          "--stdin-filepath",
          "$FILENAME",
        },
        stdin = true,
        cwd = require("conform.util").root_file({
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.json",
        }),
      },
      prettier = {
        command = "prettier",
        args = {
          "--stdin-filepath",
          "$FILENAME",
          "--config-precedence",
          "prefer-file",
        },
        stdin = true,
        cwd = require("conform.util").root_file({
          ".prettierrc",
          ".prettierrc.js",
          ".prettierrc.json",
        }),
      },
    },
    -- Log level for debugging
    log_level = vim.log.levels.DEBUG,
  },
}
