-- ===============================================================
-- Diffview — Side-by-side git diff viewer
-- ===============================================================

require("diffview").setup({
    use_icons = false,
})

local function toggle()
    local lib = require("diffview.lib")
    if lib.get_current_view() then
        vim.cmd("DiffviewClose")
    else
        vim.cmd("DiffviewOpen")
    end
end

vim.keymap.set("n", "<leader>gd", toggle, { desc = "Diffview toggle" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview file history" })
