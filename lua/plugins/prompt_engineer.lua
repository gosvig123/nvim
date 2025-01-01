return {
  "joshuavial/aider.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim", -- For system commands
  },
  config = function()
    -- Check for required Python packages
    local function ensure_dependencies()
      local Job = require("plenary.job")

      -- Check Python installation
      local python_cmd = vim.fn.executable("python3") == 1 and "python3" or "python"

      -- Required packages with specific versions
      local packages = {
        "openai>=1.0.0",
        "litellm>=1.0.0",
      }

      -- Install or upgrade packages
      for _, package in ipairs(packages) do
        Job:new({
          command = python_cmd,
          args = {"-m", "pip", "install", "--upgrade", package},
          on_exit = function(j, return_val)
            if return_val ~= 0 then
              vim.notify(
                "Failed to install " .. package .. ". Please install manually.",
                vim.log.levels.ERROR
              )
            end
          end,
        }):sync()
      end
    end

    -- Ensure dependencies before setup
    ensure_dependencies()

    require("aider").setup({
      auto_manage_context = function()
        local current_bufnr = vim.api.nvim_get_current_buf()
        local current_file = vim.api.nvim_buf_get_name(current_bufnr)
        if current_file == "" then
          return {}
        end

        -- Get diagnostic information for the current buffer
        local diagnostics = vim.diagnostic.get(current_bufnr)
        local diagnostic_context = {
          files = {},
          diagnostics = {
            current_file = current_file,
            issues = {}
          }
        }

        -- Format diagnostics with severity levels
        if #diagnostics > 0 then
          for _, diagnostic in ipairs(diagnostics) do
            local severity = vim.diagnostic.severity[diagnostic.severity]
            table.insert(diagnostic_context.diagnostics.issues, {
              line = diagnostic.lnum + 1,
              col = diagnostic.col + 1,
              message = diagnostic.message,
              severity = severity or "UNKNOWN",
              source = diagnostic.source or "unknown",
              code = diagnostic.code,
            })
          end
        end

        -- Get files in directory
        local dir = vim.fn.expand("%:p:h")
        local extensions = { ".lua", ".py", ".txt", ".js", ".ts", ".jsx", ".tsx" }

        -- Helper function to check if file is already in context
        local function is_file_in_context(file_path)
          for _, existing_file in ipairs(diagnostic_context.files) do
            if existing_file == file_path then
              return true
            end
          end
          return false
        end

        for _, ext in ipairs(extensions) do
          local found_files = vim.fn.glob(dir .. "/*" .. ext, true, true)
          for _, f in ipairs(found_files) do
            if not is_file_in_context(f) then
              table.insert(diagnostic_context.files, f)
            end
          end
        end

        return diagnostic_context
      end,
      default_bindings = true,
    })

    vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufWritePost" }, {
      callback = function()
        if require("aider").refresh_context then
          require("aider").refresh_context()
        end
      end,
    })

  end,
}