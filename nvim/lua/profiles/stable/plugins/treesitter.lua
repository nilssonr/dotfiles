-- ===============================================================
-- Tree-sitter
-- ===============================================================
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
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
  end,
}
