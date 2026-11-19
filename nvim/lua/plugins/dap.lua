-- ===============================================================
-- DAP — Debug Adapter Protocol (Go, C#, JS/TS)
-- ===============================================================
-- Keymaps are registered eagerly; each one calls ensure() first, so
-- pressing one before a go/cs/ts/js buffer has loaded still works.

-- DAP plugins load on the first go/cs/ts/js buffer, or on the first DAP
-- keymap press, whichever comes first. ensure() is idempotent.
local dap_configured = false

local function ensure()
    if dap_configured then
        return
    end
    dap_configured = true

    vim.pack.add({
        "https://github.com/mfussenegger/nvim-dap",
        "https://github.com/rcarriga/nvim-dap-ui",
        "https://github.com/nvim-neotest/nvim-nio",
    })

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

    -- JS/TS via vscode-js-debug's DAP server (only configure if installed).
    -- Install: download js-debug-dap-<ver>.tar.gz from
    -- https://github.com/microsoft/vscode-js-debug/releases and extract it
    -- into stdpath("data")/dap/, giving dap/js-debug/src/dapDebugServer.js.
    local js_debug_server = vim.fn.stdpath("data") .. "/dap/js-debug/src/dapDebugServer.js"
    if vim.fn.filereadable(js_debug_server) == 1 then
        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                args = { js_debug_server, "${port}" },
            },
        }

        local node_launch = {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
            sourceMaps = true,
        }

        dap.configurations.typescript = { node_launch }
        dap.configurations.javascript = { node_launch }
    end

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
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "cs", "typescript", "javascript" },
    once = true,
    callback = ensure,
})

-- Eager keymaps (always available)
vim.keymap.set("n", "<F5>", function() ensure(); require("dap").continue() end, { desc = "DAP continue" })
vim.keymap.set("n", "<F10>", function() ensure(); require("dap").step_over() end, { desc = "DAP step over" })
vim.keymap.set("n", "<F11>", function() ensure(); require("dap").step_into() end, { desc = "DAP step into" })
vim.keymap.set("n", "<F12>", function() ensure(); require("dap").step_out() end, { desc = "DAP step out" })
vim.keymap.set("n", "<leader>db", function() ensure(); require("dap").toggle_breakpoint() end, { desc = "DAP toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
    ensure()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP conditional breakpoint" })
vim.keymap.set("n", "<leader>dr", function() ensure(); require("dap").repl.open() end, { desc = "DAP REPL" })

