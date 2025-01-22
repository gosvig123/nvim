return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      enable_builtin = true,
      use_local_fs = true,
      default_remote = { "upstream", "origin" },
      ssh_aliases = {},
      reaction_viewer_hint_icon = "",
      picker_config = {
        use_emojis = true,
      },
      file_panel = {
        size = 10,
        use_icons = true,
      },
      mappings = { -- All mappings must be inside this table
        pull_request = {
          checkout_pr = { lhs = "<leader>po", desc = "checkout PR" },
          show_pr_diff = { lhs = "<leader>od", desc = "show PR diff" },
        },
      },
      review = {
        allow_modifiable = true,
        comment_style = "virtual",
        show_file_tree = true,
      },
      ui = {
        use_syntax_highlighting = true,
        use_signcolumn = true,
        title = "Review Resume",
      },
    }) -- Enhanced syntax highlighting setup for Octo buffers
    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "octo://*",
      callback = function()
        -- Enable Treesitter highlighting
        local ft = vim.bo.filetype
        if ft ~= "" then
          vim.cmd("TSBufEnable highlight")

          -- Ensure proper filetype detection for syntax
          local filename = vim.fn.expand("%:t")
          local detected_ft = vim.filetype.match({ filename = filename })
          if detected_ft then
            vim.bo.filetype = detected_ft
          end
        end

        -- Set up diff colors that don't interfere with syntax
        vim.cmd([[
          hi! OctoDiffAdd guibg=#283840 guifg=NONE
          hi! OctoDiffDelete guibg=#402838 guifg=NONE
          hi! OctoDiffChange guibg=#384028 guifg=NONE
          hi! link OctoBufferHeader Normal
        ]])
      end,
    })

    -- Force modifiable in Octo buffers
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
      pattern = { "octo://*", "*.octo" },
      callback = function()
        vim.schedule(function()
          vim.bo.modifiable = true
          -- Also ensure these options are set
          vim.bo.readonly = false
          vim.opt_local.conceallevel = 0
        end)
      end,
    })

    -- Keep your existing autocmds but modify the FileType one for octo
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "octo_panel", "octo" },
      callback = function()
        vim.schedule(function()
          vim.bo.modifiable = true
          vim.bo.readonly = false
          vim.opt_local.syntax = "on"
          vim.opt_local.conceallevel = 0

          -- Add buffer-local mappings to toggle modifiable
          local opts = { buffer = true, silent = true }
          vim.keymap.set("n", "<leader>tm", function()
            vim.bo.modifiable = not vim.bo.modifiable
            vim.notify("Modifiable: " .. tostring(vim.bo.modifiable), vim.log.levels.INFO)
          end, opts)
        end)
      end,
    })

    -- Add custom keymaps for review mode
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "octo",
      callback = function()
        vim.bo.modifiable = true

        local opts = { buffer = true, silent = true }
        vim.keymap.set("n", "<leader>rs", function()
          vim.cmd("write")
          vim.notify("Review changes saved", vim.log.levels.INFO)
        end, opts)

        vim.keymap.set("n", "<leader>rd", function()
          vim.cmd("e!")
          vim.notify("Review changes discarded", vim.log.levels.INFO)
        end, opts)
      end,
    })
  end,
}
