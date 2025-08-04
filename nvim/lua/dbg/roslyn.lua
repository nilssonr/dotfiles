local dap = require("dap")

dap.adapters.coreclr = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg",
  args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Launch .NET Core",
    request = "launch",
    program = function()
      return vim.fn.input("Path to DLL > ", vim.fn.getcwd() .. "/bin/Debug/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
  },
}
