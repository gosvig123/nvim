return {
  {
    "augmentcode/augment.vim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- Set workspace folders before plugin loads
      vim.g.augment_workspace_folders = {
        vim.fn.expand("~/.config/nvim"), -- Your config
        vim.fn.getcwd(), -- Current project
      }
      -- Optional customizations:
      vim.g.augment_disable_tab_mapping = false -- Keep default tab completion
      vim.g.augment_disable_completions = false -- Force enable
    end,
  },
}
