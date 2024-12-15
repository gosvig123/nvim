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
        local dir = vim.fn.expand("%:p:h")
        local extensions = { ".lua", ".py", ".txt", ".js", ".ts", ".jsx", ".tsx" }
        local files = {}
        for _, ext in ipairs(extensions) do
          local found_files = vim.fn.glob(dir .. "/*" .. ext, true, true)
          for _, f in ipairs(found_files) do
            table.insert(files, f)
          end
        end
        table.insert(files, current_file)
        return files
      end,
      default_bindings = true,
    })
  end,
}