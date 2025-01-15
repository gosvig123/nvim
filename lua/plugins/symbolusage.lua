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

      -- Add this at the top level (before any functions)
      local float_position = "top" -- Track current position

      -- Modify the create_float_window function
      local function create_float_window()
        -- Calculate dimensions for right-side float
        local width = math.floor(vim.o.columns * 0.45)
        local height = math.floor(vim.o.lines * 0.48) -- Reduced height for split view
        local col = vim.o.columns - width

        -- Calculate row based on current position
        local row
        if float_position == "top" then
          row = 1 -- Top position with small padding
          float_position = "bottom" -- Toggle for next time
        else
          row = vim.o.lines - height - 2 -- Bottom position with space for statusline
          float_position = "top" -- Toggle for next time
        end

        -- Create float window config
        local opts = {
          relative = 'editor',
          row = row,
          col = col,
          width = width,
          height = height,
          style = 'minimal',
          border = 'rounded',
          title = ' Symbol Usage ',
          title_pos = 'center',
        }

        -- Create buffer and window
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_open_win(buf, true, opts)

        -- Set window options
        vim.api.nvim_win_set_option(win, 'wrap', false)
        vim.api.nvim_win_set_option(win, 'number', true)
        vim.api.nvim_win_set_option(win, 'cursorline', true)

        return buf, win
      end

      -- Add this helper function to get the current symbol name
      local function get_current_symbol_name()
        local params = vim.lsp.util.make_position_params()
        local current_word = vim.fn.expand('<cword>')

        -- Try to get symbol info from LSP
        local result = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params, 1000)
        if result and #result > 0 then
          for _, res in pairs(result) do
            if res.result then
              for _, symbol in ipairs(res.result) do
                -- Check if symbol contains the current word
                if symbol.name and symbol.name:match(current_word) then
                  return symbol.name
                end
              end
            end
          end
        end

        -- Fallback to current word under cursor
        return current_word
      end

      -- Modify the show_location_in_float function
      local function show_location_in_float(location)
        local buf, win = create_float_window()
        local uri = location.uri or location.targetUri
        local range = location.range or location.targetSelectionRange

        -- Load file content into float buffer
        local filename = vim.uri_to_fname(uri)
        local lines = vim.fn.readfile(filename)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        -- Update window title with just the file name
        local title = string.format(" %s ", vim.fn.fnamemodify(filename, ":t"))
        vim.api.nvim_win_set_config(win, {
          title = title,
          title_pos = 'center',
        })

        -- Set cursor position
        vim.api.nvim_win_set_cursor(win, {range.start.line + 1, range.start.character})

        -- Set buffer options
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(buf, 'filetype', vim.filetype.match({ filename = filename }) or '')

        -- Add keymaps to close float window
        vim.keymap.set('n', 'q', function()
          vim.api.nvim_win_close(win, true)
        end, { buffer = buf, noremap = true })

        vim.keymap.set('n', '<Esc>', function()
          vim.api.nvim_win_close(win, true)
        end, { buffer = buf, noremap = true })
      end

      -- Update the goto_symbol_usage function
      local function goto_symbol_usage()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
          vim.notify("No LSP clients attached", vim.log.levels.WARN)
          return
        end

        local params = vim.lsp.util.make_position_params()
        params.context = { includeDeclaration = false }

        vim.lsp.buf_request(0, "textDocument/references", params, function(err, locations, ctx, _)
          if err then
            vim.notify("Error finding references: " .. tostring(err.message), vim.log.levels.ERROR)
            return
          end

          if not locations or vim.tbl_isempty(locations) then
            vim.notify("No usages found", vim.log.levels.INFO)
            return
          end

          -- Filter out current position
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
            show_location_in_float(filtered_locations[1])
          else
            -- Get current file name for the title
            local current_file = vim.fn.fnamemodify(vim.fn.expand('%'), ':t')

            -- Use telescope to select location
            require('telescope.pickers').new({}, {
              prompt_title = 'References in ' .. current_file,
              finder = require('telescope.finders').new_table({
                results = filtered_locations,
                entry_maker = function(entry)
                  local filename = vim.uri_to_fname(entry.uri or entry.targetUri)
                  local range = entry.range or entry.targetSelectionRange
                  local line = vim.fn.readfile(filename)[range.start.line + 1] or ""
                  -- Trim the line using Lua's patterns
                  line = line:gsub("^%s*(.-)%s*$", "%1")

                  return {
                    value = entry,
                    display = string.format("%s:%d - %s", vim.fn.fnamemodify(filename, ":t"), range.start.line + 1, line),
                    ordinal = filename .. line,
                    path = filename,
                    lnum = range.start.line + 1,
                    col = range.start.character + 1,
                  }
                end,
              }),
              sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
              previewer = require('telescope.previewers').new_buffer_previewer({
                define_preview = function(self, entry, _)
                  local lines = vim.fn.readfile(entry.path)
                  vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

                  -- Set the filetype for syntax highlighting with special handling for TypeScript
                  local filename = entry.path
                  local ft = vim.filetype.match({ filename = filename })

                  -- Special handling for TypeScript files
                  if vim.fn.fnamemodify(filename, ':e') == 'ts' then
                    ft = 'typescript'
                  elseif vim.fn.fnamemodify(filename, ':e') == 'tsx' then
                    ft = 'typescriptreact'
                  end

                  if ft then
                    vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', ft)

                    -- Enable syntax highlighting
                    vim.api.nvim_buf_set_option(self.state.bufnr, 'syntax', ft)

                    -- Try to use treesitter if available
                    local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
                    if ok and parsers.has_parser(ft) then
                      vim.treesitter.start(self.state.bufnr, ft)
                    end

                    -- Attach LSP if available
                    local clients = vim.lsp.get_active_clients()
                    for _, client in ipairs(clients) do
                      if client.name == "tsserver" or client.name == "typescript-tools" then
                        vim.lsp.buf_attach_client(self.state.bufnr, client.id)
                      end
                    end
                  end

                  -- Highlight the selected line
                  vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, 'TelescopePreviewLine', entry.lnum - 1, 0, -1)
                end,
              }),
              layout_config = {
                width = 0.9,
                height = 0.8,
                preview_width = 0.6,
              },
              layout_strategy = "horizontal",
              attach_mappings = function(prompt_bufnr, map)
                local actions = require('telescope.actions')
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = require('telescope.actions.state').get_selected_entry()
                  show_location_in_float(selection.value)
                end)
                return true
              end,
            }):find()
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
