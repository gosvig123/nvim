return {
  "nvim-lua/plenary.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local split = require("nui.split")
    local event = require("nui.utils.autocmd").event

    -- Create logger module
    local logger = {
      logs = {},
      panel = nil,
      ns_id = vim.api.nvim_create_namespace("custom_logger"),
    }

    -- Initialize the side panel
    local function create_log_panel()
      return split({
        relative = "editor",
        position = "right",
        size = 50,
        win_options = {
          wrap = false,
          number = false,
          foldcolumn = "0",
          signcolumn = "no",
        },
      })
    end

    -- Update the log panel content
    local function update_log_panel()
      if logger.panel and logger.panel.bufnr then
        local lines = {}
        for _, log in ipairs(logger.logs) do
          table.insert(lines, string.format("[%s] %s", log.type, vim.inspect(log.value)))
          table.insert(lines, string.rep("-", 50))
        end
        vim.api.nvim_buf_set_lines(logger.panel.bufnr, 0, -1, false, lines)
      end
    end

    -- Enhanced log function with better virtual text handling
    function _G.log_value(value, log_type)
      local line = vim.api.nvim_win_get_cursor(0)[1]
      local log_entry = {
        type = log_type or "LOG",
        value = value,
        line = line,
      }

      -- Add to logs array
      table.insert(logger.logs, log_entry)

      -- Format the value for display
      local display_value = vim.inspect(value)
      if type(value) == "string" then
        display_value = value
      end

      -- Show inline virtual text with improved visibility
      vim.api.nvim_buf_set_extmark(0, logger.ns_id, line - 1, 0, {
        virt_text = {{"📝 " .. display_value, "DiagnosticInfo"}},
        virt_text_pos = "eol",
        priority = 1000,
      })

      -- Update side panel if it exists
      if logger.panel then
        update_log_panel()
      end
    end

    -- Add console.log detection
    local function setup_console_log_capture()
      vim.api.nvim_create_autocmd({"BufWritePost", "TextChanged", "TextChangedI"}, {
        pattern = {"*.js", "*.jsx", "*.ts", "*.tsx"},
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

          -- Clear existing marks
          vim.api.nvim_buf_clear_namespace(bufnr, logger.ns_id, 0, -1)

          for i, line in ipairs(lines) do
            local log_match = line:match("console%.log%((.*%))")
            if log_match then
              -- Extract the logged value
              local value = log_match:gsub("^['\"]", ""):gsub("['\"]$", "")

              -- Show inline virtual text
              vim.api.nvim_buf_set_extmark(bufnr, logger.ns_id, i - 1, 0, {
                virt_text = {{"📝 " .. value, "DiagnosticInfo"}},
                virt_text_pos = "eol",
                priority = 1000,
              })
            end
          end
        end
      })
    end

    -- Set up highlight group for better visibility
    vim.api.nvim_set_hl(0, "LoggerVirtualText", {
      fg = "#89b4fa",
      bold = true,
    })

    -- Initialize console.log capture
    setup_console_log_capture()

    -- Command to toggle the log panel
    vim.api.nvim_create_user_command("LogPanel", function()
      if logger.panel then
        logger.panel:unmount()
        logger.panel = nil
      else
        logger.panel = create_log_panel()
        logger.panel:mount()
        update_log_panel()

        -- Close panel with 'q'
        logger.panel:map("n", "q", function()
          logger.panel:unmount()
          logger.panel = nil
        end, { noremap = true })
      end
    end, {})

    -- Command to clear all logs
    vim.api.nvim_create_user_command("LogClear", function()
      logger.logs = {}
      vim.api.nvim_buf_clear_namespace(0, logger.ns_id, 0, -1)
      if logger.panel then
        update_log_panel()
      end
    end, {})

    -- Add keymaps
    vim.keymap.set("n", "<leader>ll", ":LogPanel<CR>", { desc = "Toggle Log Panel" })
    vim.keymap.set("n", "<leader>lc", ":LogClear<CR>", { desc = "Clear Logs" })
  end
}