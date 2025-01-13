return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      use_local_fs = false,
      default_remote = {"upstream", "origin"},
      gh_env = {
        DELTA_PAGER = "less -R",
      },
      viewer = {
        tool = "delta",
        options = {
          side_by_side = true,
          line_numbers = true,
          navigate = true,
          features = "decorations",
          syntax_theme = "tokyonight",
          plus_style = "bold green",
          minus_style = "bold red",
          zero_style = "dim syntax",
          keep_plus_minus_markers = true,
          hyperlinks = true,
          file_style = "bold yellow ul",
          hunk_header_style = "bold syntax",
        }
      },
      file_panel = {
        size = 15,
        use_icons = true,
        fold_only_large_diffs = true,
        fold_threshold = 50,
        win_config = {
          relative = "editor",
          border = "rounded",
          width = 50,
          height = 70,
          row = 1,
          col = vim.api.nvim_get_option("columns") - 51,
          style = "minimal",
          title = "Changed Files",
          title_pos = "center",
        },
      },
      diff_view = {
        use_icons = true,
        enhanced_diff_hl = true,
        signs = {
          add = "│",
          delete = "│",
          change = "│",
          changedelete = "~",
        },
        file_panel = {
          size = 15,
          use_icons = true,
          win_config = {
            relative = "editor",
            border = "rounded",
            width = 40,
            height = 70,
            row = 1,
            col = vim.api.nvim_get_option("columns") - 51,
            style = "minimal",
            title = "Changed Files",
            title_pos = "center",
          },
        },
      },
      mappings = {
        pull_request = {
          checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
          merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
          squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
          list_commits = { lhs = "<space>pc", desc = "list PR commits" },
          list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
          add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
          remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
          close_pr = { lhs = "<space>pc", desc = "close PR" },
          reopen_pr = { lhs = "<space>po", desc = "reopen PR" },
          list_prs = { lhs = "<space>pl", desc = "list open PRs on same repo" },
          next_diff = { lhs = "]d", desc = "next diff" },
          prev_diff = { lhs = "[d", desc = "previous diff" },
          next_diff_hunk = { lhs = "]d", desc = "next diff hunk" },
          prev_diff_hunk = { lhs = "[d", desc = "previous diff hunk" },
          toggle_files = { lhs = "<leader>pf", desc = "toggle files panel" },
          toggle_viewed = { lhs = "<leader>pv", desc = "toggle viewed state" },
          toggle_diff_view = { lhs = "<leader>pd", desc = "toggle diff view style" },
          toggle_side_by_side = { lhs = "<leader>os", desc = "toggle side by side" },
        },
        review_thread = {
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        }
      },
      commands = {
        review_start = {
          lhs = "<leader>or",
          desc = "start/resume review with floating files panel",
          callback = function()
            -- Check if there's an ongoing review
            local has_review = pcall(vim.cmd, "Octo review resume")

            if not has_review then
              -- Try to start a new review and capture any errors
              local success, result = pcall(vim.cmd, "Octo review start")

              if not success then
                -- Check if we're in a PR context
                local pr_check = pcall(vim.cmd, "Octo pr list")
                if not pr_check then
                  vim.notify("Error: Not in a PR context. Please open a PR first.", vim.log.levels.ERROR)
                  return
                end

                -- If we are in a PR but still can't start review, might be auth issues
                vim.notify("Error starting review. Please check your GitHub authentication.", vim.log.levels.ERROR)
                return
              end
            end

            -- Short delay to ensure review is initialized
            vim.defer_fn(function()
              -- Check if we're in a valid review context
              local valid_review = pcall(vim.cmd, "Octo review status")

              if valid_review then
                -- Close any existing panels first
                pcall(vim.cmd, "Octo pr close-file-panel")
                -- Show diff view
                vim.cmd("Octo pr diff")
                -- Open floating file panel
                vim.cmd("Octo pr files")
              else
                vim.notify("Failed to initialize review. Please try again.", vim.log.levels.WARN)
              end
            end, 100)
          end
        }
      }
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"octo"},
      callback = function()
        vim.opt_local.diffopt:append("algorithm:patience")
        vim.opt_local.diffopt:append("indent-heuristic")
        vim.opt_local.diffopt:append("context:3")

        vim.cmd([[
          hi OctoDiffAdd guifg=#4fd6be guibg=#1e2a3d
          hi OctoDiffDelete guifg=#ff757f guibg=#2d1e2e
          hi OctoDiffChange guifg=#ffc777 guibg=#1e2a3d
        ]])

        vim.keymap.set("n", "<leader>fz", function()
          vim.cmd("Octo pr files")
        end, { buffer = true, desc = "Toggle file panel" })

        vim.keymap.set("n", "<leader>fq", function()
          vim.cmd("Octo pr refresh")
        end, { buffer = true, desc = "Reload files" })
      end
    })
  end,
  keys = {
    { "<leader>o", desc = "Octo" },
    { "<leader>op", "<cmd>Octo pr list<cr>", desc = "List PRs" },
    { "<leader>or", "<cmd>Octo review resume<cr>", desc = "Resume Review" },
  },
}
