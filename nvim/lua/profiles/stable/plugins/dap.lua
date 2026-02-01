return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "DAP continue" },
    { "<F10>", function() require("dap").step_over() end, desc = "DAP step over" },
    { "<F11>", function() require("dap").step_into() end, desc = "DAP step into" },
    { "<F12>", function() require("dap").step_out() end, desc = "DAP step out" },
    { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
    {
      "<leader>B",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "DAP conditional breakpoint",
    },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP REPL" },
  },
  dependencies = {
    "mxsdev/nvim-dap-vscode-js",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local util = require("core.util")
    local dap = require("dap")
    local dapui = require("dapui")

    -- .env file reader for injecting env vars into debug sessions
    local function read_env_file(path)
      if vim.fn.filereadable(path) ~= 1 then
        return {}
      end

      local env = {}
      for _, line in ipairs(vim.fn.readfile(path)) do
        local trimmed = vim.trim(line)
        if trimmed ~= "" and not trimmed:match("^#") then
          trimmed = trimmed:gsub("^export%s+", "")
          local key, value = trimmed:match("^([^=]+)=(.*)$")
          if key and value then
            key = vim.trim(key)
            value = vim.trim(value)
            local first = value:sub(1, 1)
            local last = value:sub(-1)
            if (first == "'" and last == "'") or (first == "\"" and last == "\"") then
              value = value:sub(2, -2)
            end
            env[key] = value
          end
        end
      end
      return env
    end

    local function load_env_from_cwd()
      local env_path = vim.fn.getcwd() .. "/.env"
      local env = read_env_file(env_path)
      if next(env) == nil then
        util.warn(("No .env file found at %s"):format(env_path))
      end
      return env
    end

    -- Adapters
    dap.adapters.go = {
      type = "server",
      host = "127.0.0.1",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    }

    dap.adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }

    -- Go configurations
    dap.configurations.go = {
      {
        type = "go",
        name = "Debug package",
        request = "launch",
        program = "${fileDirname}",
      },
      {
        type = "go",
        name = "Debug caser (serve)",
        request = "launch",
        program = "${workspaceFolder}",
        args = { "serve" },
        env = load_env_from_cwd,
      },
      {
        type = "go",
        name = "Debug file",
        request = "launch",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug tests",
        request = "launch",
        mode = "test",
        program = "${fileDirname}",
      },
    }

    -- C# configurations
    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Launch (pick dll)",
        request = "launch",
        program = function()
          return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
      },
    }

    -- JS/TS via vscode-js-debug
    local js_debug_path = vim.fn.stdpath("data") .. "/dap/vscode-js-debug"
    if vim.fn.isdirectory(js_debug_path) ~= 1 then
      util.warn(("Missing vscode-js-debug at %s. See README.md for install steps."):format(js_debug_path))
    end

    require("dap-vscode-js").setup({
      debugger_path = js_debug_path,
      adapters = { "pwa-node" },
    })

    local node_launch = {
      type = "pwa-node",
      request = "launch",
      name = "Launch file (node)",
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "node",
      sourceMaps = true,
      protocol = "inspector",
    }

    dap.configurations.typescript = { node_launch }
    dap.configurations.javascript = { node_launch }

    -- Auto-open/close DAP UI with debug session lifecycle
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    if not util.executable("dlv") then
      util.warn("Missing delve (dlv). Install: brew install delve")
    end
    if not util.executable("netcoredbg") then
        util.warn("Missing netcoredbg. Build/install it (see nvim/README.md).")
    end
  end,
}
