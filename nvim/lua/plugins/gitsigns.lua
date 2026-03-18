-- ===============================================================
-- Gitsigns — Git change indicators and inline blame
-- ===============================================================
-- Plain text signs (no nerd-font icons). Inline blame enabled by default.

require("gitsigns").setup({
    signs = {
        add = { text = "|" },
        change = { text = "|" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "|" },
    },
    current_line_blame = true,
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
})

local gs = require("gitsigns")
vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next hunk" })
vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })
