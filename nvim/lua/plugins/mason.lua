return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      --      require("lsp") -- this loads your lua/lsp/init.lua
    end,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      registries = {
        "github:Crashdummyy/mason-registry",
        "github:mason-org/mason-registry",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "gopls",
        "ts_ls",
        "rust_analyzer"
      },
      automatic_installation = false,
    },
  },
}
