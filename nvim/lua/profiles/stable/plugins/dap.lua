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
  },
  config = function()
    local util = require("core.util")
    local dap = require("dap")

    -- Maintain adapters here; easy to add/remove.
    local adapters = {
      go = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      },
      coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      },
    }

    dap.adapters.go = adapters.go
    dap.adapters.coreclr = adapters.coreclr

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

    -- Optional: warn if debuggers missing
    if not util.executable("dlv") then
      util.warn("Missing delve (dlv). Install: brew install delve")
    end
    if not util.executable("netcoredbg") then
      util.warn("Missing netcoredbg. Install: brew install netcoredbg")
    end
  end,
}
