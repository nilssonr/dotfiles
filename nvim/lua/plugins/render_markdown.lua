-- ===============================================================
-- Render Markdown — In-buffer markdown rendering
-- ===============================================================

require("render-markdown").setup({
    latex = { enabled = false }, -- no latex parser/converter installed
})

vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Markdown: Toggle render" })
