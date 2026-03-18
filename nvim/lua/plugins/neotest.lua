-- ===============================================================
-- Neotest — Test runner (Go, .NET)
-- ===============================================================
-- Keymaps are registered eagerly so they appear in which-key.
-- The actual neotest setup runs on first FileType go/cs via pack.lua.

local function dotnet_suite_root()
    local cwd = vim.fn.getcwd()
    local repo = vim.fn.fnamemodify(cwd, ":t")

    local overrides = {}

    local override = overrides[repo] or overrides[cwd]
    if override then
        return vim.fn.fnamemodify(cwd .. "/" .. override, ":p")
    end

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

-- Eager keymaps (lazy-require pattern)
vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end, { desc = "Test nearest" })
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Test file" })
vim.keymap.set("n", "<leader>ts", function() require("neotest").run.run(suite_root()) end, { desc = "Test suite" })
vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, { desc = "Test output" })
vim.keymap.set("n", "<leader>tS", function() require("neotest").summary.toggle() end, { desc = "Test summary" })
vim.keymap.set("n", "<leader>tr", function() require("neotest").run.run_last() end, { desc = "Test last" })

local M = {}

function M.setup()
    require("neotest").setup({
        adapters = {
            require("neotest-go"),
            require("neotest-dotnet"),
        },
    })
end

return M
