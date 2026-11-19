-- ===============================================================
-- Neotest — Test runner (Go, .NET)
-- ===============================================================
-- Keymaps are registered eagerly so they appear in which-key. Neotest
-- loads on the first go/cs buffer (core/pack.lua) or the first keymap
-- press, whichever comes first. M.ensure() is idempotent.

local function dotnet_suite_root()
    local cwd = vim.fn.getcwd()
    if vim.fn.isdirectory(cwd .. "/src") == 1 then
        return cwd .. "/src"
    end
    return cwd
end

local function suite_root()
    if vim.bo.filetype == "cs" then
        return dotnet_suite_root()
    end
    return vim.fn.getcwd()
end

local M = {}
local loaded = false

function M.ensure()
    if loaded then
        return
    end
    loaded = true
    vim.pack.add({
        "https://github.com/nvim-neotest/nvim-nio",
        "https://github.com/nvim-neotest/neotest",
        "https://github.com/nvim-neotest/neotest-go",
        "https://github.com/Issafalcon/neotest-dotnet",
    })
    require("neotest").setup({
        adapters = {
            require("neotest-go"),
            require("neotest-dotnet"),
        },
    })
end

local function neotest()
    M.ensure()
    return require("neotest")
end

-- Eager keymaps
vim.keymap.set("n", "<leader>tn", function() neotest().run.run() end, { desc = "Test nearest" })
vim.keymap.set("n", "<leader>tf", function() neotest().run.run(vim.fn.expand("%")) end, { desc = "Test file" })
vim.keymap.set("n", "<leader>ts", function() neotest().run.run(suite_root()) end, { desc = "Test suite" })
vim.keymap.set("n", "<leader>to", function() neotest().output.open({ enter = true }) end, { desc = "Test output" })
vim.keymap.set("n", "<leader>tS", function() neotest().summary.toggle() end, { desc = "Test summary" })
vim.keymap.set("n", "<leader>tr", function() neotest().run.run_last() end, { desc = "Test last" })

return M
