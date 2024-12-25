return {
  "joshuavial/aider.nvim",
  event = "VeryLazy",
  config = function()
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

        for _, ext in ipairs(extensions) do
          local found_files = vim.fn.glob(dir .. "/*" .. ext, true, true)
          for _, f in ipairs(found_files) do
            table.insert(diagnostic_context.files, f)
          end
        end

        return diagnostic_context
      end,
      default_bindings = true,
    })

    -- Create autocmd to refresh context when diagnostics change
    vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufWritePost" }, {
      callback = function()
        -- Force aider to refresh context
        if require("aider").refresh_context then
          require("aider").refresh_context()
        end
      end,
    })
  end,
}