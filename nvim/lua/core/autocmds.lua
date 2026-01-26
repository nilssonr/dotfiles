-- ===============================================================
-- Autocommands
-- ===============================================================

-- ===============================================================
-- Highlight on yank
-- ===============================================================
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 120 }) -- brief highlight of yanked text
    end,
})

-- ===============================================================
-- Format on save (explicit, predictable)
-- ===============================================================
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        -- Only format real file buffers
        if vim.bo.buftype ~= "" then
            return
        end

        require("core.format").format_current_buffer() -- format before write
    end,
})

-- ===============================================================
-- Tree-sitter highlighting per filetype
-- ===============================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "lua",
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "yaml",
        "toml",
        "go",
        "rust",
        "cs",
        "c_sharp",
        "xml",
        "norg",
    },
    callback = function()
        vim.treesitter.start() -- start tree-sitter highlighting
    end,
})

-- ===============================================================
-- Neorg conceal tweaks
-- ===============================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = "norg",
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
    end,
})

-- ===============================================================
-- Close quickfix/location list after selecting an entry
-- ===============================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "<CR>", function()
            local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1] or {}
            local is_loclist = wininfo.loclist == 1

            vim.cmd("normal! <CR>")

            if is_loclist then
                vim.cmd("lclose")
            else
                vim.cmd("cclose")
            end
        end, { buffer = true, silent = true })
    end,
})


-- ===============================================================
-- Ensure that the first item is selected in auto completes
-- ===============================================================
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        vim.opt.completeopt = { "menu", "menuone", "noinsert" }
    end,
})
