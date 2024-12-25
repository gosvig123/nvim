return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("telescope").setup({
      extensions = {
        file_browser = {
          hidden = false,
          hide_parent_dir = true,
          display_stat = false,
          hide_mode_bits = true,
          path_display = function(opts, path)
            return vim.fn.fnamemodify(path, ":t")
          end,

          display_info = false,
          git_status = false,
          grouped = false,
          dir_icon = "📁",
          dir_icon_hl = "Directory",
          disable_devicons = false,
          use_fd = false,
          depth = 5,
          select_buffer = true,
          hidden_files = false,
          quiet = true,
          no_ignore = false,
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.75,
              width = 0.9,
              height = 0.9,
              preview_cutoff = 0,
            },
            prompt_position = "bottom",
          },
          sorting_strategy = "ascending",
        },
      },
    })

    require("telescope").load_extension("file_browser")

    vim.keymap.set("n", "<leader>ot", function()
      require("telescope").extensions.file_browser.file_browser({
        path = "%:p:h",
        respect_gitignore = true,
        hidden = false,
        grouped = true,
        previewer = true,
        initial_mode = "insert",
        layout_strategy = "horizontal",
        display_stat = false,
        hide_mode_bits = true,
        path_display = { "smart" },
        display_info = false,
        git_status = false,
        disable_devicons = false,
        use_fd = false,
        depth = 1,
        select_buffer = true,
        hidden_files = false,
        quiet = true,
        no_ignore = false,
        layout_config = {
          preview_width = 0.75,
          width = 0.9,
          height = 0.9,
        },
      })
    end, { noremap = true, desc = "File Browser" })
  end,
}
