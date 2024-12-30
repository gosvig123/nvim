return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Debuggers
        "debugpy",
        "js-debug-adapter",

        -- Python tools
        "ruff",
        "ruff-lsp",
        "pyright",
        "black",

        -- JavaScript/TypeScript tools
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
}