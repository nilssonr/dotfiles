local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all (force)" })

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics float" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- LSP (buffer-local maps are set in lsp.lua on_attach)
-- Format (global fallback)
map("n", "<leader>f", function()
    require("core.format").format_current_buffer()
end, { desc = "Format buffer" })

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
