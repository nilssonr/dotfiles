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

vim.keymap.set("n", "<leader>gd", toggle, { desc = "Diffview toggle (working tree)" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview repo history" })
vim.keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview current file history" })

-- Compare working tree / branches / commits against an arbitrary git rev.
-- Accepts anything DiffviewOpen does: "main", "origin/main...HEAD", "HEAD~3",
-- "d4a7b0d..519b30e", etc.
vim.keymap.set("n", "<leader>gc", function()
    vim.ui.input({ prompt = "Diff against (rev/range/branch): " }, function(input)
        if input and input ~= "" then
            vim.cmd("DiffviewOpen " .. input)
        end
    end)
end, { desc = "Diffview compare against rev" })
