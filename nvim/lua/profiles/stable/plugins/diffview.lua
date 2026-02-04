return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
        { "<leader>df", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
        { "<leader>dF", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
        { "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview file history" },
    },
    opts = {},
}
