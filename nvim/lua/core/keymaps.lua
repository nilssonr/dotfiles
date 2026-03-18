-- ===============================================================
-- Keymaps — Global and LSP buffer-local key bindings
-- ===============================================================
-- 0.12 provides default LSP keymaps: grr (references), gra (code action),
-- grn (rename), gri (implementation), K (hover), <C-S> (signature help).
-- Default diagnostic keymaps: [d/]d (navigate), <C-W>d (float).
-- Only gd (definition) needs manual mapping.

local map = vim.keymap.set

-- Basic
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all (force)" })

-- Delete to black hole so yanked text isn't overwritten
map("x", "x", '"_d', { desc = "Delete without yanking" })
map("x", "X", '"_d', { desc = "Delete without yanking" })

map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })
map("n", "<leader>bD", function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
            vim.cmd("confirm bd " .. buf)
        end
    end
end, { desc = "Close all buffers (prompt if unsaved)" })

-- Format — routes through core.format which handles XML specially, falls back to LSP
map("n", "<leader>f", function()
    require("core.format").format_current_buffer()
end, { desc = "Format buffer" })

-- LSP keymaps (buffer-local, set once per buffer)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- gd is the only LSP keymap not provided by 0.12 defaults
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })

        if client and client.name == "roslyn" then
            vim.keymap.set("n", "<leader>lR", "<cmd>Roslyn restart<cr>", { buffer = bufnr, desc = "Restart Roslyn" })
        end
    end,
})

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
