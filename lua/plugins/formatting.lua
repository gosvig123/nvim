return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = {
      format_on_save = false,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier", "eslint" },
        typescript = { "prettier", "eslint" },
        javascriptreact = { "prettier", "eslint" },
        typescriptreact = { "prettier", "eslint" },
        python = { "black", "isort" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        css = { "prettier", "stylelint" },
        scss = { "prettier", "stylelint" },
        less = { "prettier", "stylelint" },
        sh = { "shfmt" }
      },
      formatters = {
        stylua = {
          prepend_args = {
            "--column-width=120",
            "--indent-type=Spaces",
            "--indent-width=2"
          }
        },
        prettier = {
          prepend_args = {
            "--print-width=120",
            "--tab-width=2",
            "--single-quote",
            "--trailing-comma=es5"
          }
        },
        black = {
          prepend_args = {
            "--line-length=120",
            "--fast",
            "--preview",
            "--quiet"
          }
        },
        isort = {
          prepend_args = {
            "--profile=black",
            "--line-length=88",
            "--multi-line=3",
            "--lines-after-imports=2",
            "--lines-between-types=1",
            "--combine-as",
            "--case-sensitive=true"
          }
        },
        shfmt = {
          prepend_args = {
            "-i",
            "2",
            "-bn",
            "-ci"
          }
        },
        eslint = {
          prepend_args = {
            "--fix",
            "--cache"
          }
        }
      }
    }
  }
}
