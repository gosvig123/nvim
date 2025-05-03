return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      -- Keymaps for Git operations using Fugitive
      vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git Status (Fugitive)" })
      vim.keymap.set("n", "<leader>ghs", ":Git add %<CR>", { desc = "Stage Current File" })
      vim.keymap.set("n", "<leader>ghS", ":Git add .<CR>", { desc = "Stage All Files" })
      vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git Commit" })
      vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git Push" })
      vim.keymap.set("n", "<leader>gl", ":Git pull<CR>", { desc = "Git Pull" })
      vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git Diff" })
      vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git Blame" })
      -- For staging hunks or parts of a file, you can use visual mode + :Git add
      vim.keymap.set("n", "<leader>ghp", ":Git add -p %<CR>", { desc = "Stage Hunks Interactively for Current File" })
    end,
  },
}
