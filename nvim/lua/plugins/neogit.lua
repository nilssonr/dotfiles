-- ===============================================================
-- Neogit — Git interface
-- ===============================================================

require("neogit").setup({
    integrations = {
        diffview = true,
    },
})

vim.keymap.set("n", "<leader>gg", function()
    require("neogit").open()
end, { desc = "Neogit" })
