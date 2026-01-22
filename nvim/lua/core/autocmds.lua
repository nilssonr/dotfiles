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
-- Tree-sitter highlighting is enabled by Neovim and must be started per filetype
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
    },
    callback = function()
        vim.treesitter.start() -- start tree-sitter highlighting
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
