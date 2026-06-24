-- ===============================================================
-- Todo Comments — highlight + search TODO/FIXME/HACK/NOTE
-- ===============================================================
-- Plain signs (no nerd-font icons) to match the rest of the UI. The manual
-- Todo/@comment.todo highlights in theme.lua remain; this adds per-keyword
-- coloring and search commands on top.

require("todo-comments").setup({
    signs = false,
})

vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev TODO" })
