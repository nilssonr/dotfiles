-- ===============================================================
-- Neovim 0.12 Configuration — Entry point
-- ===============================================================
-- Uses native vim.pack, vim.lsp.config/enable, and blink.cmp.
-- Leader keys must be set before any plugin loads.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.diagnostics").setup()

-- Plugins (vim.pack.add + lazy loading + config)
require("core.pack")

-- LSP: blink.cmp's plugin/blink-cmp.lua merges its capabilities into
-- vim.lsp.config("*"). vim.lsp.enable() skips any server whose cmd binary
-- isn't executable when it would start (logged to :LspLog), so no PATH
-- check is needed here.
vim.lsp.enable({ "gopls", "rust_analyzer", "ts_ls", "angularls", "yamlls", "taplo", "jsonls", "bashls", "lua_ls", "elp" })

-- Startup screen
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("ui.intent").show()
    end,
})
