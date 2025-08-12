local dap = require("dap")

-- Adapter: use netcoredbg from Mason; only the supported flag
dap.adapters.coreclr = dap.adapters.coreclr or {
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg",
    args = { "--interpreter=vscode" },
}

-- Helper to guess a Debug DLL path (netX.Y)
local function guess_debug_dll()
    local guess = vim.fn.glob(vim.fn.getcwd() .. "/bin/Debug/*/*.dll")
    if guess ~= "" then return guess end
    return vim.fn.getcwd() .. "/bin/Debug/"
end

-- Configurations for C#
dap.configurations.cs = dap.configurations.cs or {
    {
        type = "coreclr",
        name = "Launch .NET Core",
        request = "launch",
        program = function()
            return vim.fn.input("Path to DLL > ", guess_debug_dll(), "file")
        end,
        cwd = vim.fn.getcwd(), -- use actual cwd; DAP doesn’t expand ${workspaceFolder} here
        stopAtEntry = false,
    },
    {
        type = "coreclr",
        name = "Attach to Process",
        request = "attach",
        processId = require("dap.utils").pick_process,
    },
}
