return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Debuggers
        "debugpy",
        "js-debug-adapter",

        -- Python tools

        -- CSS tools
        "css-lsp",
        "stylelint-lsp",
      },
    },
  },
}
