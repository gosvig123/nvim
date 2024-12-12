return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      -- Set Gemini as the default adapter for both chat and inline strategies
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
      -- Configure the Gemini adapter

      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            -- Configure environment variables
            env = {
              api_key = "AIzaSyAA9LCNlkLqc7eY-MTgm8iXq2EGuSr4fJ4"
            },
            -- Optional: Configure model settings
            schema = {
              model = {
                default = "gemini-2.0-flash-exp", -- Currently the only available model
              },
              temperature = {
                default = 0.8, -- Lower temperature for more focused coding responses
              },
            },
          })
        end,
      },
      -- Optional: Configure display settings
      display = {
        -- Show diff view when making inline edits
        diff = {
          provider = "mini_diff", -- or "diffview"
        },
      },
    })

    -- Optional: Set up some useful keymaps
    vim.keymap.set("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
    vim.keymap.set("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
    vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanion Chat" })
    vim.keymap.set("v", "<leader>cc", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanion Chat" })
  end,
}
