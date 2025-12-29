-- ===============================================================
-- Git Signs
-- ===============================================================
return {
    "lewis6991/gitsigns.nvim", -- git signs in gutter
    event = { "BufReadPre", "BufNewFile" }, -- load on file open
    opts = {
        -- No fancy icons; keep it plain.
        signs = {
            add = { text = "|" }, -- added line
            change = { text = "|" }, -- changed line
            delete = { text = "_" }, -- deleted line
            topdelete = { text = "‾" }, -- deleted at top
            changedelete = { text = "~" }, -- changed then deleted
            untracked = { text = "|" }, -- untracked line
        },

        -- Blame
        current_line_blame = false, -- toggle on demand
        current_line_blame_opts = {
            virt_text = true, -- show blame inline
            virt_text_pos = "eol", -- end of line
            delay = 200, -- delay in ms
            ignore_whitespace = false, -- consider whitespace
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> • <summary>", -- blame text

        -- Performance
        watch_gitdir = { follow_files = true }, -- follow moved/renamed files
        sign_priority = 6, -- sign priority
        update_debounce = 100, -- debounce updates (ms)
    },
    config = function(_, opts)
        require("gitsigns").setup(opts) -- initialize gitsigns

        local gs = require("gitsigns") -- gitsigns module
        local map = vim.keymap.set -- keymap helper

        -- Toggle inline blame for current line
        map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Git blame (toggle line)" })

        -- Hunk navigation
        map("n", "]h", gs.next_hunk, { desc = "Next hunk" })
        map("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })

        -- Hunk actions (optional but useful)
        map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
        map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
    end,
}
