return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "telescope.nvim",
    },
    opts = {
      debug = false,
      show_help = true,
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)

      -- Get staged files using git command
      local function get_staged_files()
        local handle = io.popen("git diff --cached --name-only")
        if not handle then return {} end

        local result = handle:read("*a")
        handle:close()

        local files = {}
        for file in result:gmatch("[^\r\n]+") do
          table.insert(files, file)
        end
        return files
      end

      -- Function to analyze file content with CopilotChat
      local function analyze_files(files)
        -- Prepare content from all files
        local all_content = {}
        for _, file_path in ipairs(files) do
          local lines = vim.fn.readfile(file_path)
          if #lines > 0 then
            local ext = vim.fn.fnamemodify(file_path, ":e")
            local lang = ext ~= "" and ext or "text"
            table.insert(all_content, string.format("\n### File: %s (%s)\n```%s\n%s\n```",
              file_path, lang, lang, table.concat(lines, "\n")))
          end
        end

        if #all_content == 0 then
          vim.notify("No content to analyze", vim.log.levels.WARN)
          return
        end

        -- Create the prompt
        local prompt = string.format([[
Analyze the following staged files and provide:
1. potential issues/bugs
2. potential improvements
3. readability and variable names
4. Code quality assessment

Files to analyze:
%s
]], table.concat(all_content, "\n"))

        -- Use CopilotChat's API directly
        require("CopilotChat").ask(prompt, {
          context = table.concat(all_content, "\n"),
          mode = "v",
          window = {
            layout = "float",
            relative = "editor",
            width = 0.8,
            height = 0.8,
            row = 0.1,
            col = 0.1,
          },
        })
      end

      -- Function to analyze all staged files
      local function analyze_staged_files()
        local files = get_staged_files()
        if #files == 0 then
          vim.notify("No staged files found", vim.log.levels.WARN)
          return
        end

        analyze_files(files)
      end

      -- Add keymap for analyzing staged files
      vim.keymap.set("n", "<leader>cn", analyze_staged_files, { desc = "Analyze all staged files with Copilot" })
    end,
  }
}