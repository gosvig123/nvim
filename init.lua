local env = require("env")
vim.env.DEEPSEEK_API_KEY = env.DEEPSEEK_API_KEY
-- display all secrets when starting neovim
-- vim.cmd("set shortmess+=I")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
