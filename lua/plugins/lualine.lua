return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "SmiteshP/nvim-navic",
        opts = {
          lsp = {
            auto_attach = true,
            preference = nil
          },
          highlight = true,
          separator = " > ",
          depth_limit = 0,
          depth_limit_indicator = "..",
          safe_output = true,
          click = true,
        },
      },
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      local function get_location()
        local parser = vim.treesitter.get_parser()
        if not parser then return "" end

        local current_node = vim.treesitter.get_node()
        if not current_node then return "" end

        local nodes = {}
        while current_node do
          local node_type = current_node:type()
          if node_type ~= "program" and node_type ~= "source" then
            -- Get the node text
            local text = vim.treesitter.get_node_text(current_node, 0)

            -- Find named nodes for different types
            local name_node = nil
            if node_type == "function_declaration" then
              name_node = current_node:field("name")[1]
            elseif node_type == "method_declaration" then
              name_node = current_node:field("name")[1]
            elseif node_type == "class_declaration" then
              name_node = current_node:field("name")[1]
            elseif node_type == "function_definition" then  -- Python functions
              name_node = current_node:field("name")[1]
            elseif node_type == "class_definition" then     -- Python classes
              name_node = current_node:field("name")[1]
            end

            -- If we found a name node, get its text
            if name_node then
              local name = vim.treesitter.get_node_text(name_node, 0)
              if name and name ~= "" then
                table.insert(nodes, 1, name)
              end
            end
          end
          current_node = current_node:parent()
        end

        return #nodes > 0 and table.concat(nodes, " > ") or ""
      end

      return {
        winbar = {
          lualine_a = { "branch" },
          lualine_b = {
            { "filename", path = 1 },
          },
          lualine_c = {
            {
              function()
                return get_location()
              end,
            }
          },
          lualine_x = {
            "filetype",
            {
              function()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                return string.format("Ln %d, Col %d", row, col + 1)
              end,
            }
          },
          lualine_y = {},
          lualine_z = {},
        },
        sections = {},
        inactive_sections = {},
      }
    end,
  }
}
