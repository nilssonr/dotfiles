-- ===============================================================
-- Telescope — Fuzzy finder with fzf-native extension
-- ===============================================================
-- fzf-native provides significantly faster sorting on large repos.
-- The native extension is built via PackChanged hook in core/pack.lua.

local telescope = require("telescope")

telescope.setup({
    defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        file_ignore_patterns = { "%.git/" },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        layout_config = {
            horizontal = {
                prompt_position = "bottom",
                preview_width = 0.55,
            },
            width = 0.85,
            height = 0.80,
        },
    },
})

-- Load fzf-native for faster sorting
pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
