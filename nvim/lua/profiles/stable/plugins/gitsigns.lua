return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "|" },
            change = { text = "|" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "|" },
        },
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 200,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> • <summary>",
        watch_gitdir = { follow_files = true },
        sign_priority = 6,
        update_debounce = 100,
    },
    config = function(_, opts)
        require("gitsigns").setup(opts)

        local gs = require("gitsigns")
        local map = vim.keymap.set

        map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Git blame (toggle line)" })
        map("n", "]h", gs.next_hunk, { desc = "Next hunk" })
        map("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })
        map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
        map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
    end,
}
