-- ===============================================================
-- Tree-sitter
-- ===============================================================
return {
    "nvim-treesitter/nvim-treesitter", -- tree-sitter integration
    lazy = false, -- load immediately
    build = ":TSUpdate", -- update parsers on install
    config = function()
        -- New rewrite API: setup + install
        require("nvim-treesitter").setup({}) -- initialize tree-sitter

        -- Install a sensible baseline set (add/remove from this table)
        require("nvim-treesitter").install({
            "lua", -- Lua
            "typescript", -- TypeScript
            "tsx", -- TSX
            "javascript", -- JavaScript
            "json", -- JSON
            "yaml", -- YAML
            "toml", -- TOML
            "go", -- Go
            "rust", -- Rust
            "c_sharp", -- C#
        })
    end,
}
