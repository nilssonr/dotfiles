-- ===============================================================
-- Trouble — diagnostics / references / quickfix list UI
-- ===============================================================
-- ASCII glyphs only (no nerd-font), matching the rest of the UI.

require("trouble").setup({
    icons = {
        indent = {
            top = "│ ",
            middle = "├╴",
            last = "└╴",
            fold_open = "▾",
            fold_closed = "▸",
            ws = "  ",
        },
        folder_closed = "[+]",
        folder_open = "[-]",
        kinds = {
            Array = "[]", Boolean = "bool", Class = "cls", Constant = "const",
            Constructor = "new", Enum = "enum", EnumMember = "mbr", Event = "evt",
            Field = "fld", File = "file", Function = "fn", Interface = "iface",
            Key = "key", Method = "meth", Module = "mod", Namespace = "ns",
            Null = "null", Number = "num", Object = "obj", Operator = "op",
            Package = "pkg", Property = "prop", String = "str", Struct = "struct",
            TypeParameter = "T", Variable = "var",
        },
    },
})

local map = vim.keymap.set
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
map("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "LSP references" })
map("n", "<leader>xs", "<cmd>Trouble lsp_document_symbols toggle<cr>", { desc = "Document symbols" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
