return {
  {
    "ldelossa/litee.nvim",
    event = "VeryLazy",
    opts = {
      notify = { enabled = false },
      panel = {
        orientation = "right",
        panel_size = 50,
      },
    },
    config = function(_, opts)
      require("litee.lib").setup(opts)
    end,
  },
  {
    "ldelossa/litee-calltree.nvim",
    dependencies = "ldelossa/litee.nvim",
    event = "VeryLazy",
    opts = {
      on_open = "panel", -- Or "float"
      map_resize_keys = false, -- Set to true if you want default resize keymaps
      keymaps = {
        expand = ">",
        collapse = "<",
        collapse_all = "zM",
        jump_vsplit = "<CR>", -- Jump to location in vsplit
      },
    },
    config = function(_, opts)
      require("litee.calltree").setup(opts)

      -- Example keymaps (optional) - Place these in your keymap config
      vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Calltree Incoming Calls" })
      vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Calltree Outgoing Calls" })
    end,
  },
}
