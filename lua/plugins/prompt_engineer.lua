return {
    "jackielii/prompt_engineer.nvim",
    config = function()
        require("prompt_engineer").setup({
            -- Options for prompt_engineer.nvim
            google = { -- Configuration for Google Gemini
                api_key = os.getenv("GOOGLE_API_KEY"), -- Set your Google API key
            }
        })
    end,
}
