return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    enabled = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "mxsdev/nvim-dap-vscode-js",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate" },
    },
    config = function()
      local status_ok, dap = pcall(require, "dap")
      if not status_ok then
        vim.notify("Failed to load nvim-dap", vim.log.levels.ERROR)
        return
      end

      -- Configure virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = 'eol',
        all_frames = true,
        virt_lines = false,
        virt_text_win_col = nil
      })

      -- Set up UI
      require("dapui").setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.5 },      -- Variables and scope info
              { id = "watches", size = 0.5 },      -- Watch expressions
            },
            position = "right",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 1 },          -- Debug REPL
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Configure Node.js/TypeScript debugging
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            js_debug_path .. "/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        }
      }

      -- Add Chrome debug adapter for React applications
      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            js_debug_path .. "/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        }
      }

      -- Configure debug configurations for TypeScript/JavaScript
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome against localhost",
            url = function()
              local port = vim.fn.input("Port number (default 3000): ")
              port = port ~= "" and port or "3000"
              return "http://localhost:" .. port
            end,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
            sourceMapPathOverrides = {
              -- Next.js specific mappings
              ["webpack:///./*"] = "${webRoot}/*",
              ["webpack:///./~/*"] = "${webRoot}/node_modules/*",
              ["webpack://?:*/*"] = "${webRoot}/*",
              ["webpack://_N_E/*"] = "${webRoot}/*",
              ["webpack://(app-pages-browser)/./*"] = "${webRoot}/*",
              ["webpack://(app-client)/./*"] = "${webRoot}/*"
            },
            skipFiles = {
              "<node_internals>/**",
              "**/node_modules/**",
              "**/webpack/**"
            },
            outFiles = {
              "${workspaceFolder}/.next/static/chunks/**/*.js",
              "${workspaceFolder}/.next/server/**/*.js"
            }
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (Node)",
            cwd = "${workspaceFolder}",
            args = { "${file}" },
            sourceMaps = true,
            protocol = "inspector",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- Python Debugging Setup with Conda support
      require("dap-python").setup(
        vim.env.CONDA_PREFIX and
        vim.env.CONDA_PREFIX .. "/bin/python" or
        vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      )

      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" }
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch Python File",
          program = "${file}",
          pythonPath = function()
            return vim.env.CONDA_PREFIX and
              vim.env.CONDA_PREFIX .. "/bin/python" or
              vim.fn.exepath("python") or
              "/usr/bin/python"
          end,
          args = function()
            local input = vim.fn.input("Input arguments: ")
            return vim.split(input, " +")
          end,
          console = "integratedTerminal",
          justMyCode = false,
          autoReload = { enable = true }
        },
        {
          type = "python",
          request = "attach",
          name = "Attach to Process",
          processId = require("dap.utils").pick_process,
          pythonPath = function()
            return vim.env.CONDA_PREFIX and
              vim.env.CONDA_PREFIX .. "/bin/python" or
              vim.fn.exepath("python")
          end,
        }
      }

      -- Configure debug signs with emojis
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "👉", texthl = "DapStopped", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "⭕", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

      -- Automatically open UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
      end
    end,
  },
}