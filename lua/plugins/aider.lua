return {
  "joshuavial/aider.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("aider").setup({
      -- Default configuration
      auto_manage_context = true,
      default_bindings = true,
      debug = true,
      backends = {
        get_coq = require("aider.backend").get_coq,
        get_gemini = function()
          return require("prompt_engineer").google
        end,
        get_llm = require("aider.backend").get_llm, -- Keep this line for other LLM options
      },
      chat_model = "gemini-1.5-flash-latest",
      default_prompts = {
        code_edit = "Please help me edit the code to accomplish the following:",
        git_commit = "Please help me write a git commit message for the following changes:",
      },
    })

    -- Add keymaps (optional - only if you want custom keymaps)
    vim.api.nvim_set_keymap('n', '<leader>oa', '<cmd>lua AiderOpen()<cr>', {noremap = true, silent = true})
    vim.keymap.set("n", "<leader>as", "<cmd>AiderStart<cr>", { desc = "Start Aider" })
    vim.keymap.set("n", "<leader>ap", "<cmd>AiderPrompt<cr>", { desc = "Aider Prompt" })
    vim.keymap.set("v", "<leader>ae", "<cmd>AiderEdit<cr>", { desc = "Aider Edit Selection" })
  end,
}
