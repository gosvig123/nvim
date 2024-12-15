vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    print("Client capabilities:", vim.inspect(client.server_capabilities))
  end,
})

return {

  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local SymbolKind = vim.lsp.protocol.SymbolKind
      local function text_format(symbol)
        local fragments = {}

        if symbol.references then
          local usage = symbol.references <= 1 and 'usage' or 'usages'
          local num = symbol.references == 0 and 'no' or symbol.references
          table.insert(fragments, ('%s %s'):format(num, usage))
        end

        return table.concat(fragments, ', ')
      end

      require("symbol-usage").setup({
        text_format = text_format,
        kinds = {
          SymbolKind.Function,
          SymbolKind.Method,
          SymbolKind.Class,
          SymbolKind.Interface,
          SymbolKind.Module,
          SymbolKind.Variable,
        },
        references = { enabled = true, include_declaration = false },
        definition = { enabled = false },
        implementation = { enabled = false },
        vt_position = 'end_of_line',
        display_virtual_text = true,
        hl = { link = "Comment" },
        request_pending_text = "calculating...",
        symbol_request_pos = 'end',
      })

      -- Add custom function to handle symbol navigation
      local function goto_symbol_usage()
        -- Debug: Check LSP client
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
          vim.notify("No LSP clients attached", vim.log.levels.WARN)
          return
        end

        local params = vim.lsp.util.make_position_params()
        -- Add context parameter explicitly
        params.context = {
          includeDeclaration = false
        }

        vim.lsp.buf_request(0, "textDocument/references", params, function(err, locations, ctx, _)
          if err then
            vim.notify("Error finding references: " .. tostring(err.message), vim.log.levels.ERROR)
            return
          end

          if not locations or vim.tbl_isempty(locations) then
            vim.notify("No usages found", vim.log.levels.INFO)
            return
          end

          -- Filter out the current position
          local filtered_locations = vim.tbl_filter(function(loc)
            local uri = loc.uri or loc.targetUri
            local range = loc.range or loc.targetSelectionRange
            local current_pos = vim.api.nvim_win_get_cursor(0)
            local current_line = current_pos[1] - 1
            local current_char = current_pos[2]

            return uri ~= vim.uri_from_bufnr(0) or
                   range.start.line ~= current_line or
                   range.start.character ~= current_char
          end, locations)

          if #filtered_locations == 0 then
            vim.notify("No other usages found", vim.log.levels.INFO)
            return
          end

          if #filtered_locations == 1 then
            -- Jump directly to the single location
            local loc = filtered_locations[1]
            local uri = loc.uri or loc.targetUri
            local range = loc.range or loc.targetSelectionRange

            vim.api.nvim_command("edit " .. vim.uri_to_fname(uri))
            vim.api.nvim_win_set_cursor(0, {range.start.line + 1, range.start.character})
          else
            -- Show telescope picker for multiple locations
            require('telescope.builtin').lsp_references({
              show_line = true,
              include_declaration = false,
              jump_type = 'never',
            })
          end
        end)
      end

      -- Add the keymapping
      vim.keymap.set("n", "gt", goto_symbol_usage, { desc = "Go to symbol usage" })

      vim.keymap.set("n", "<leader>sU", function()
        require('symbol-usage').toggle()
      end, { desc = "Toggle Symbol Usage" })
    end,
  },
}
