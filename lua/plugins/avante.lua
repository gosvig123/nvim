return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = "gemini",
      gemini = {
        model = "gemini-2.5-flash-preview-04-17",
        temperature = 0.5,
        max_tokens = 40096,
      },
      openai = {
        enabled = false,
      },
      -- Disable Anthropic by default to avoid API key errors
      anthropic = {
        enabled = false,
      },
      -- Enable web search capabilities
      web_search_engine = {
        provider = "tavily", -- Options: tavily, serpapi, searchapi, google, kagi, brave, or searxng
        proxy = nil, -- Set a proxy if needed, e.g., "http://127.0.0.1:7890"
      },
      -- UI settings
      border = "rounded",
      max_lines = 10,
      auto_complete = false, -- Disable auto-completion as we'll use Augment for this
      auto_complete_delay = 300,
      keymaps = {
        accept = "<Tab>",
        dismiss = "<C-]>",
        next_snippet_choice = "<C-l>",
        prev_snippet_choice = "<C-h>",
      },
      -- Providers configuration
      providers = {
        ["copilot"] = { enabled = false }, -- Disable Copilot as a completion provider
        ["buffer"] = { enabled = true, priority = 60 },
        ["path"] = { enabled = true, priority = 50 },
      },
      -- Disable in certain contexts
      disable_in = {
        filetypes = { "TelescopePrompt" },
        buftypes = { "terminal", "prompt" },
      },
      -- Build command for Avante
      build = function()
        -- Check if we're on Windows
        if vim.fn.has("win32") == 1 then
          return "powershell -ExecutionPolicy Bypass -File Build.ps1"
        else
          return "make"
        end
      end,
      dependencies = {
        "augmentcode/augment.vim", -- Ensure Augment is loaded as a dependency
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              use_absolute_path = true,
            },
          },
        },
        {
          "MeanderingProgrammer/render-markdown.nvim",
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
      config = function(_, opts)
        -- Set up custom highlights
        vim.api.nvim_set_hl(0, "AvanteNormal", { fg = "#d8dee9", bg = "NONE" })
        vim.api.nvim_set_hl(0, "AvanteAccent", { fg = "#79b8ff", bg = "NONE", bold = true })

        -- Initialize Avante with the options
        require("avante").setup(opts)

        -- Set up keymaps for Avante
        vim.keymap.set("n", "<leader>at", function()
          require("avante").toggle()
        end, { desc = "Toggle Avante" })

        vim.keymap.set("n", "<leader>as", function()
          require("avante").status()
        end, { desc = "Avante Status" })
      end,
    },
  },
}
