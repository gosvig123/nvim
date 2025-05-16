return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- Uncomment the following line to load hub lazily
    -- cmd = "MCPHub",  -- lazy load
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- Uncomment this if you don't want mcp-hub to be available globally or can't use -g
    -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts
    config = function()
      require("mcphub").setup({
        -- Default port for MCP Hub
        port = 37373,
        -- Config file location (will create if not exists)
        config = vim.fn.expand("~/.config/mcphub/servers.json"),
        -- Auto approve mcp tool calls
        auto_approve = true,
        -- Let LLMs start and stop MCP servers automatically
        auto_toggle_mcp_servers = true,
        -- Extensions configuration
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          }
        },
        -- Default window settings
        ui = {
          window = {
            width = 0.8,
            height = 0.8,
            relative = "editor",
            zindex = 50,
            border = "rounded",
          },
        },
        -- Logging configuration
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
  },
}
