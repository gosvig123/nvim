local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
    cache = {
      enabled = true,
      -- Don't cache files in runtime path
      path = vim.fn.stdpath("cache") .. "/lazy/cache",
      -- Don't cache files from runtime
      disable_events = { "VimEnter", "BufReadPre" },
    },
  },
})

-- Place in lua/config/autocmds.lua
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_get_current_buf()
    local windows = vim.api.nvim_list_wins()

    -- If there's only one window, proceed with buffer cleanup
    if #windows == 1 then
      local bufs = vim.fn.getbufinfo({ buflisted = 1 })

      for _, buf in ipairs(bufs) do
        if buf.bufnr ~= current_buf and vim.bo[buf.bufnr].buftype == "" and vim.api.nvim_buf_is_valid(buf.bufnr) then
          vim.api.nvim_buf_delete(buf.bufnr, { force = true })
        end
      end
    else
      -- For multiple windows, only clean buffers in current window
      local win_bufs = {}
      for _, win in ipairs(windows) do
        if win ~= current_win then
          win_bufs[vim.api.nvim_win_get_buf(win)] = true
        end
      end

      local bufs = vim.fn.getbufinfo({ buflisted = 1 })
      for _, buf in ipairs(bufs) do
        if
          buf.bufnr ~= current_buf
          and not win_bufs[buf.bufnr]
          and vim.bo[buf.bufnr].buftype == ""
          and vim.api.nvim_buf_is_valid(buf.bufnr)
        then
          vim.api.nvim_buf_delete(buf.bufnr, { force = true })
        end
      end
    end
  end,
})
