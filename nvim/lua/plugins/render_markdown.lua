-- ===============================================================
-- Render Markdown — In-buffer markdown rendering
-- ===============================================================

require("render-markdown").setup({})

vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Markdown: Toggle render" })
