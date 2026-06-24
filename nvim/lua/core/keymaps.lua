-- ===============================================================
-- Keymaps — Global and LSP buffer-local key bindings
-- ===============================================================
-- 0.12 provides default LSP keymaps: gd (definition), grr (references),
-- gra (code action), grn (rename), gri (implementation), K (hover),
-- <C-S> (signature help). Default diagnostic keymaps: [d/]d, <C-W>d.

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
map("n", "<leader>cf", function()
    require("core.format").format_current_buffer()
end, { desc = "Format buffer" })

-- LSP keymaps (buffer-local, set once per buffer)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client.name == "roslyn" then
            vim.keymap.set("n", "<leader>lR", "<cmd>Roslyn restart<cr>", { buffer = bufnr, desc = "Restart Roslyn" })
        end

        -- Inlay hints on by default for any server that supports them
        if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end,
})

-- Toggle inlay hints globally
map("n", "<leader>ci", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = "Toggle inlay hints" })

-- Editing QoL
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
-- Move the visual selection up/down, re-indenting as it goes
map("x", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("x", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
