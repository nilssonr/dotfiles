-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 120 })
    end,
})

-- Format on save (only real file buffers)
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if vim.bo.buftype ~= "" then
            return
        end
        require("core.format").format_current_buffer()
    end,
})

-- Neorg needs conceallevel for rendering
vim.api.nvim_create_autocmd("FileType", {
    pattern = "norg",
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
    end,
})

-- Close quickfix/location list after selecting an entry
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "<CR>", function()
            local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1] or {}
            local is_loclist = wininfo.loclist == 1
            local line = vim.fn.line(".")

            vim.cmd((is_loclist and "ll " or "cc ") .. line)

            if is_loclist then
                vim.cmd("lclose")
            else
                vim.cmd("cclose")
            end
        end, { buffer = true, silent = true })
    end,
})

-- Ensure first completion item is selected (reinforces options.lua setting)
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        vim.opt.completeopt = { "menu", "menuone", "noinsert" }
    end,
})
