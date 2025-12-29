return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        -- New rewrite API: setup + install
        require("nvim-treesitter").setup({})

        -- Install a sensible baseline set (add/remove from this table)
        require("nvim-treesitter").install({
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
        })
    end,
}
