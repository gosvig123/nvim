return {
  {
    "echasnovski/mini.diff",
    event = "VeryLazy",
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
      {
        "<leader>gO",
        function()
          -- First enable mini.diff if it's disabled
          if vim.g.minidiff_disable == true then
            vim.g.minidiff_disable = false
            require("mini.diff").enable(0)
            vim.defer_fn(function() vim.cmd([[redraw!]]) end, 100)
          end
          -- Then toggle overlay
          vim.defer_fn(function()
            require("mini.diff").toggle_overlay(0)
          end, 150)
        end,
        desc = "Enable mini.diff and toggle overlay",
      },
    },
    opts = {
      -- Customize the view for better visibility
      view = {
        style = "sign", -- Use sign column for better visibility
        signs = {
          add = "+", -- Subtle vertical bar for additions
          change = "▎", -- Subtle vertical bar for changes
          delete = "▔", -- Thicker horizontal line for deletions to make them more visible
        },
        priority = 200, -- Higher priority to ensure visibility
      },
      -- Customize overlay view for better visibility
      options = {
        algorithm = "histogram", -- Better diff algorithm
        indent_heuristic = true,
        linematch = 80, -- Increase line matching for better diff
      },
      -- Configure the delay for responsiveness
      delay = {
        text_change = 150, -- Slightly faster updates
      },
    },
    config = function(_, opts)
      require("mini.diff").setup(opts)

      -- Set up custom highlights for better visibility
      vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#4fd6be", bg = "NONE" }) -- Bright cyan-green
      vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#ffc777", bg = "NONE" }) -- Warm yellow
      vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#ff5370", bg = "#331a1a" }) -- Brighter red with background for deletions

      -- Enhanced overlay highlights for better visibility
      vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { fg = "#4fd6be", bg = "#1a3328" }) -- Subtle green background
      vim.api.nvim_set_hl(0, "MiniDiffOverChange", { fg = "#ffc777", bg = "#332b1a" }) -- Subtle yellow background
      vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { fg = "#ff5370", bg = "#331a1a", bold = true, strikethrough = true }) -- Red background + strikethrough for deletions
      vim.api.nvim_set_hl(0, "MiniDiffOverContext", { fg = "#565f89", bg = "NONE" }) -- Subtle context color

      -- Add highlights for line number style as well
      vim.api.nvim_set_hl(0, "MiniDiffSignAddLine", { fg = "#4fd6be", bg = "NONE" }) -- Line number for additions
      vim.api.nvim_set_hl(0, "MiniDiffSignChangeLine", { fg = "#ffc777", bg = "NONE" }) -- Line number for changes
      vim.api.nvim_set_hl(0, "MiniDiffSignDeleteLine", { fg = "#ff5370", bg = "#331a1a", bold = true }) -- Line number for deletions with background

      -- Create an autocmd to refresh highlights when colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#4fd6be", bg = "NONE" })
          vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#ffc777", bg = "NONE" })
          vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#ff5370", bg = "#331a1a" })
          vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { fg = "#4fd6be", bg = "#1a3328" })
          vim.api.nvim_set_hl(0, "MiniDiffOverChange", { fg = "#ffc777", bg = "#332b1a" })
          vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { fg = "#ff5370", bg = "#331a1a", bold = true, strikethrough = true })
          vim.api.nvim_set_hl(0, "MiniDiffOverContext", { fg = "#565f89", bg = "NONE" })
          vim.api.nvim_set_hl(0, "MiniDiffSignAddLine", { fg = "#4fd6be", bg = "NONE" })
          vim.api.nvim_set_hl(0, "MiniDiffSignChangeLine", { fg = "#ffc777", bg = "NONE" })
          vim.api.nvim_set_hl(0, "MiniDiffSignDeleteLine", { fg = "#ff5370", bg = "#331a1a", bold = true })
        end,
      })
    end,
  },

  -- Add toggle functionality
  {
    "mini.diff",
    opts = function()
      if Snacks and Snacks.toggle then
        Snacks.toggle({
          name = "Mini Diff Signs",
          get = function()
            return vim.g.minidiff_disable ~= true
          end,
          set = function(state)
            vim.g.minidiff_disable = not state
            if state then
              require("mini.diff").enable(0)
            else
              require("mini.diff").disable(0)
            end
            -- HACK: redraw to update the signs
            vim.defer_fn(function()
              vim.cmd([[redraw!]])
            end, 200)
          end,
        }):map("<leader>uG")
      end
    end,
  },
}
