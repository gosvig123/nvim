return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    dependencies = { -- Add bufferline as explicit dependency
      "akinsho/bufferline.nvim",
      version = "*", -- Ensure latest compatible version
    },
    init = function() -- Initialize bufferline first
      require("bufferline").setup()
    end,
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Edgy Toggle",
      },
    -- stylua: ignore
    { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
    },
    opts = function()
      -- [Keep your existing opts configuration here]
      -- ... (all your existing opts content remains the same) ...
    end,
  },
}
