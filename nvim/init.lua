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

-- LSP: merge blink.cmp capabilities, disable snippets, then enable servers
local capabilities = require("blink.cmp").get_lsp_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
vim.lsp.config("*", { capabilities = capabilities })

-- Enable servers (skip those whose binary isn't on PATH)
local util = require("core.util")
local servers = { "gopls", "rust_analyzer", "ts_ls", "angularls", "yamlls", "taplo", "jsonls", "bashls", "lua_ls" }
local enabled = {}
for _, name in ipairs(servers) do
    local cfg = vim.lsp.config[name]
    -- angularls uses a function cmd — always include; others check binary
    if type(cfg) == "table" and type(cfg.cmd) == "table" and cfg.cmd[1] and not util.executable(cfg.cmd[1]) then
        -- skip
    else
        table.insert(enabled, name)
    end
end
vim.lsp.enable(enabled)

-- Startup screen
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("ui.intent").show()
    end,
})
