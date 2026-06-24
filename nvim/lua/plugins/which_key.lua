-- ===============================================================
-- Which Key — Keymap hint popup
-- ===============================================================

local wk = require("which-key")

wk.setup({
    icons = {
        breadcrumb = "",
        separator = "",
        group = "",
    },
})

-- Group labels for leader prefixes
wk.add({
    { "<leader>c", group = "code" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>d", group = "debug" },
    { "<leader>b", group = "buffer" },
    { "<leader>t", group = "test" },
})
