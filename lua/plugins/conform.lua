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
          "--fix-dry-run",
          "--stdin",
          "--stdin-filename",
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
        args = function(self, ctx)
          local ext = vim.fn.fnamemodify(ctx.filename, ":e")
          local parser = ({
            js = "babel",
            jsx = "babel",
            tsx = "typescript",
            ts = "typescript",
          })[ext] or ext

          return {
            "--stdin-filepath",
            ctx.filename,
            "--parser",
            parser,
            "--config-precedence",
            "prefer-file",
          }
        end,
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
