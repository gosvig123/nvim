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
        return
      end

      local dapui = require("dapui")

      -- Set up UI
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.55 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks", size = 0.25 },
            },
            position = "right",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 1 },
            },
            position = "top",
            size = 15,
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

      -- Configure Node.js/TypeScript configurations
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File (pwa-node)",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.typescript = dap.configurations.javascript

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
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
      vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate" })

      -- Add keymaps for initiating debug
      vim.keymap.set("n", "<leader>ds", function()
        if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" then
          dap.run(dap.configurations.javascript[1])
        elseif vim.bo.filetype == "python" then
          dap.run({
            type = "python",
            request = "launch",
            name = "Launch Current File",
            program = "${file}",
            pythonPath = vim.fn.exepath("python"),
          })
        end
      end, { desc = "Start Debugging" })
    end,
  },
}