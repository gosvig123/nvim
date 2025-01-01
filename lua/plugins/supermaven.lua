return {
  "supermaven-inc/supermaven-nvim",
  event = "VeryLazy",
  config = function()
    vim.notify("Setting up supermaven-nvim")

    -- Helper function to check for diagnostics near cursor and get suggestion
    local function handle_diagnostic_suggestion()
      local current_bufnr = vim.api.nvim_get_current_buf()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local cursor_line = cursor[1] - 1

      local diagnostics = vim.diagnostic.get(current_bufnr)
      for _, diagnostic in ipairs(diagnostics) do
        if math.abs(diagnostic.lnum - cursor_line) <= 2 then
          local suggestion = require("supermaven-nvim.completion_preview")
          if suggestion and suggestion.has_suggestion and suggestion.has_suggestion() then
            return true
          end
        end
      end
      return false
    end

    -- Setup expand function and expose it globally
    _G.supermaven_expand = function(fallback)
      local suggestion = require("supermaven-nvim.completion_preview")
      if handle_diagnostic_suggestion() then
        -- Suggestion exists, accept it
        vim.schedule(function()
          suggestion.on_accept_suggestion()
        end)
        return ""
      end
      -- If no suggestion, use fallback
      return fallback()
    end

    require("supermaven-nvim").setup({
      disable_keymaps = true,
      keymaps = {
        accept_suggestion = false,
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { cpp = true },
      color = {
        suggestion_color = "#00ff00",
        cterm = 244,
      },
      log_level = "info",
      disable_inline_completion = false,
    })

    -- Create autocmd to refresh suggestions when diagnostics change
    vim.api.nvim_create_autocmd({ "DiagnosticChanged", "CursorMoved" }, {
      callback = function()
        -- Only check for suggestion existence, don't accept
        handle_diagnostic_suggestion()
      end,
    })

    -- Set up the keymap to use the expand function directly
    vim.keymap.set("i", "<Tab>", function()
      return vim.fn.luaeval([[supermaven_expand(function() return vim.api.nvim_replace_termcodes('<Tab>', true, true, true) end)]])
    end, { expr = true, silent = true })

    vim.notify("Supermaven-nvim setup complete")
  end,
  dependencies = {
    "hrsh7th/nvim-cmp",
  }
}
