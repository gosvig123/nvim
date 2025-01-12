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
        -- Try conda environment first
        local conda_prefix = vim.fn.getenv("CONDA_PREFIX")
        if conda_prefix and conda_prefix ~= "" then
          if vim.fn.has("win32") == 1 then
            return conda_prefix .. "\\python.exe"
          end
          return conda_prefix .. "/bin/python"
        end

        -- Try poetry environment first
        local poetry_env = vim.fn.system("poetry env info -p 2>/dev/null")
        if vim.v.shell_error == 0 and poetry_env ~= "" then
          local path = vim.fn.trim(poetry_env)
          if vim.fn.has("win32") == 1 then
            return path .. "\\Scripts\\python.exe"
          end
          return path .. "/bin/python"
        end

        -- Try virtualenv
        local venv = vim.fn.getenv("VIRTUAL_ENV")
        local venv_str = type(venv) == "string" and venv or nil
        if venv_str then
          if vim.fn.has("win32") == 1 then
            return venv_str .. "\\Scripts\\python.exe"
          end
          return venv_str .. "/bin/python"
        end

        -- Try pyenv
        local pyenv_path = vim.fn.trim(vim.fn.system("pyenv which python 2>/dev/null"))
        if vim.v.shell_error == 0 and pyenv_path ~= "" then
          return pyenv_path
        end

        -- System Python fallbacks
        local python3 = vim.fn.exepath("python3")
        if python3 and python3 ~= "" then
          return python3
        end

        local python = vim.fn.exepath("python")
        if python and python ~= "" then
          return python
        end

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
          justMyCode = false,
          args = {"-Xfrozen_modules=off"},
          env = {
            PYTHONPATH = "${workspaceFolder}${pathSeparator}${env:PYTHONPATH}",
          },
          stopOnEntry = false,
          debugOptions = {
            "RedirectOutput",
            "DebugStdLib",
            "ShowReturnValue",
          },
        },
        {
          type = "python",
          request = "attach",
          name = "Attach to Process",
          connect = function()
            local host = vim.fn.input("Host (default: 127.0.0.1): ")
            local port = vim.fn.input("Port (default: 5678): ")

            -- Use defaults if no input provided
            host = host ~= "" and host or "127.0.0.1"
            port = port ~= "" and tonumber(port) or 5678

            -- Validate port number
            if not port or port < 1 or port > 65535 then
              vim.notify("Invalid port number. Using default port 5678", vim.log.levels.WARN)
              port = 5678
            end

            return {
              host = host,
              port = port
            }
          end,
          pathMappings = {
            {
              localRoot = "${workspaceFolder}",
              remoteRoot = "."
            }
          },
          justMyCode = false,
          pythonPath = get_python_path(),
          debugOptions = {
            "RedirectOutput",
            "DebugStdLib",
            "ShowReturnValue",
          },
        },
        {
          type = "python",
          request = "attach",
          name = "Attach by Process ID",
          processId = function()
            local output = vim.fn.system("ps -x | grep python")
            local lines = vim.split(output, "\n")
            local processes = {}

            for _, line in ipairs(lines) do
              local pid = line:match("^%s*(%d+)")
              if pid then
                local process_info = line:gsub("^%s*%d+%s*", "")
                table.insert(processes, { name = process_info, id = tonumber(pid) })
              end
            end

            -- Create selection menu for processes
            return vim.ui.select(processes, {
              prompt = "Select Python Process:",
              format_item = function(item)
                return string.format("%d: %s", item.id, item.name)
              end,
            }, function(choice)
              return choice and choice.id or nil
            end)
          end,
          pythonPath = get_python_path(),
          debugOptions = {
            "RedirectOutput",
            "DebugStdLib",
            "ShowReturnValue",
          },
        }
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
          url = function()
            local port = vim.fn.input("Port number (default 3000): ")
            -- Use 3000 as default if no input provided
            port = port ~= "" and port or "3000"
            return "http://localhost:" .. port
          end,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          sourceMapPathOverrides = {
            -- Next.js specific mappings
            ["webpack://_N_E/./*"] = "${webRoot}/*",
            ["webpack:///./*"] = "${webRoot}/*",
            ["webpack:///./~/*"] = "${webRoot}/node_modules/*",
            ["webpack://?:*/*"] = "${webRoot}/*",
            ["webpack://(app-pages-browser)/./*"] = "${webRoot}/*",
            ["webpack://(app-client)/./*"] = "${webRoot}/*",
            ["webpack://_N_E/*"] = "${webRoot}/*",
            -- Handle pnpm structure
            ["webpack:///./node_modules/.pnpm/*"] = "${webRoot}/node_modules/.pnpm/*"
          },
          skipFiles = {
            "<node_internals>/**",
            "**/node_modules/**",
            "**/.next/**",
            "**/webpack/**"
          },
          outFiles = {
            "${workspaceFolder}/.next/static/chunks/**/*.js",
            "${workspaceFolder}/.next/server/**/*.js",
            "${workspaceFolder}/.next/static/development/**/*.js"
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

        if filetype == "python" then
          if not dap.configurations.python then
            vim.notify("No debug configuration found for Python", vim.log.levels.ERROR)
            return
          end

          -- Verify Python interpreter
          local python_path = get_python_path()
          local check_python = vim.fn.system(python_path .. " --version")
          if vim.v.shell_error ~= 0 then
            vim.notify("Invalid Python interpreter: " .. python_path, vim.log.levels.ERROR)
            return
          end

          -- Create selection menu for Python debug configurations
          vim.ui.select({
            { name = "Launch file", index = 1 },
            { name = "Attach to port", index = 2 },
            { name = "Attach by Process ID", index = 3 }
          }, {
            prompt = "Select Python Debug Configuration:",
            format_item = function(item)
              return item.name
            end,
          }, function(choice)
            if choice then
              local status_ok, err = pcall(function()
                dap.run(dap.configurations.python[choice.index])
              end)
              if not status_ok then
                vim.notify("Failed to start debugger: " .. tostring(err), vim.log.levels.ERROR)
              end
            end
          end)
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