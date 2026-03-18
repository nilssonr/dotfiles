-- ===============================================================
-- Treesitter — Syntax highlighting and indentation
-- ===============================================================
-- TSUpdate is handled via PackChanged hook in core/pack.lua.

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua",
        "typescript",
        "tsx",
        "javascript",
        "json",
        "yaml",
        "toml",
        "go",
        "rust",
        "c_sharp",
    },
    highlight = { enable = true },
    indent = { enable = true },
})
