-- ===============================================================
-- Keymaps
-- ===============================================================
local map = vim.keymap.set -- keymap helper

-- ===============================================================
-- Basic
-- ===============================================================
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" }) -- save buffer
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" }) -- quit window
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all (force)" }) -- quit all without prompts

-- ===============================================================
-- Diagnostics
-- ===============================================================
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics float" }) -- show diagnostic popup
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" }) -- previous diagnostic
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" }) -- next diagnostic

-- ===============================================================
-- Formatting
-- ===============================================================
-- LSP (buffer-local maps are set in lsp.lua on_attach)
-- Format (global fallback)
map("n", "<leader>f", function()
    require("core.format").format_current_buffer() -- format current buffer
end, { desc = "Format buffer" })

-- ===============================================================
-- Terminal
-- ===============================================================
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" }) -- exit terminal mode
