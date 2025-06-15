return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      provider = "copilot", -- default AI assistant provider
      behaviour = {
        -- Configuration for project root detection
        root_dir = {
          -- Markers to identify project root
          markers = {
            ".git",
            "package.json",
            "Cargo.toml",
          },
          -- Fallback to current working directory if no markers found
          fallback = vim.fn.getcwd,
        },
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "stevearc/dressing.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
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
      -- System prompt configuration
      opts.system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        if hub then
          return hub:get_active_servers_prompt()
        else
          return "You are a helpful AI assistant."
        end
      end

      -- Custom tools configuration
      opts.custom_tools = function()
        local mcphub_ext = require("mcphub.extensions.avante")
        if mcphub_ext and mcphub_ext.mcp_tool then
          return {
            mcphub_ext.mcp_tool(),
          }
        else
          return {}
        end
      end

      -- Initialize Avante with the options
      require("avante").setup(opts)

      -- Set up keymaps
      vim.keymap.set('n', '<leader>aa', '<cmd>Avante<CR>', { desc = 'Open Avante' })
      vim.keymap.set('v', '<leader>aa', ':Avante<CR>', { desc = 'Open Avante with selection' })
      vim.keymap.set('n', '<leader>ac', '<cmd>AvanteContext<CR>', { desc = 'Add context to Avante' })
      vim.keymap.set('n', '<leader>at', '<cmd>AvanteToggle<CR>', { desc = 'Toggle Avante window' })
    end
  }
}
