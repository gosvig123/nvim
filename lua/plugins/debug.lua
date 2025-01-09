return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    enabled = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
      "mxsdev/nvim-dap-vscode-js",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
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

      local status_ok_ui, dapui = pcall(require, "dapui")
      if not status_ok_ui then
        vim.notify("Failed to load nvim-dap-ui", vim.log.levels.ERROR)
        return
      end

      -- Set up UI
      dapui.setup({
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
            position = "top",
            size = 20,
          },
        },
      })

      -- Automatically open UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Configure Python adapter with virtual environment support
      local function get_python_path()
        -- Try to get virtual environment path
        local venv = vim.fn.getenv("VIRTUAL_ENV")
        local venv_str = type(venv) == "string" and venv or nil

        if venv_str then
          if vim.fn.has("win32") == 1 then
            return venv_str .. "\\Scripts\\python.exe"
          end
          return venv_str .. "/bin/python"
        end

        -- Fallback to system Python
        local python3 = vim.fn.exepath("python3")
        if python3 and python3 ~= "" then
          return python3
        end

        local python = vim.fn.exepath("python")
        if python and python ~= "" then
          return python
        end

        -- Final fallback
        return "python"
      end

      require("dap-python").setup(get_python_path())

      -- Python configuration
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = get_python_path(),
          console = "integratedTerminal",
        },
      }

      -- Configure Node.js adapter with proper path resolution
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

      -- Configure debug configurations
      dap.configurations.javascript = {
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome against localhost",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          sourceMapPathOverrides = {
            -- More specific Next.js mappings
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
        }
      }

      -- Share configurations
      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.javascript
      dap.configurations.javascriptreact = dap.configurations.javascript

      -- Configure debug signs
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "👉", texthl = "DapStopped", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "⭕", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

      -- Keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Set Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
      vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate" })

      -- Add keymaps for initiating debug
      vim.keymap.set("n", "<leader>ds", function()
        local filetype = vim.bo.filetype

        -- Debug logging
        vim.notify("Starting debug for filetype: " .. filetype, vim.log.levels.INFO)

        -- Check if DAP is properly loaded
        local dap_ok, dap = pcall(require, "dap")
        if not dap_ok then
          vim.notify("Debug adapter protocol (DAP) not found", vim.log.levels.ERROR)
          return
        end

        -- Log available configurations
        vim.notify("Available configurations: " .. vim.inspect(dap.configurations), vim.log.levels.INFO)

        -- Check if we have a configuration for the current filetype
        if filetype == "javascript" or filetype == "typescript" or filetype == "typescriptreact" or filetype == "javascriptreact" then
          if not dap.configurations.javascript then
            vim.notify("No debug configuration found for JavaScript/TypeScript", vim.log.levels.ERROR)
            return
          end
          dap.run(dap.configurations.javascript[1])
        elseif filetype == "python" then
          if not dap.configurations.python then
            vim.notify("No debug configuration found for Python", vim.log.levels.ERROR)
            return
          end
          dap.run({
            type = "python",
            request = "launch",
            name = "Launch Current File",
            program = "${file}",
            pythonPath = vim.fn.exepath("python"),
          })
        else
          vim.notify("Debugging not configured for filetype: " .. filetype, vim.log.levels.WARN)
        end
      end, { desc = "Start Debugging" })

      -- Keep your watch expression keymap
      vim.keymap.set("n", "<leader>dw", function()
        local expr = vim.fn.input("Watch expression: ")
        require("dapui").elements.watches.add(expr)
      end, { desc = "Add Watch Expression" })
    end,
  },
}