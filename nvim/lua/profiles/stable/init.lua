-- ===============================================================
-- Stable Profile
-- ===============================================================
local M = {} -- module table

function M.setup()
    -- Core editor behavior first
    require("core.options")             -- editor options
    require("core.keymaps")             -- key mappings
    require("core.autocmds")            -- autocommands
    require("core.diagnostics").setup() -- diagnostic UI settings

    -- Load plugins for this profile
    require("core.lazy").setup({
        { import = "profiles.stable.plugins" }, -- stable plugin specs
    })

    require("core.roslyn").setup() -- roslyn server config (C#)

    -- LSP after plugins are available (cmp_nvim_lsp capabilities, etc.)
    require("core.lsp").setup() -- language server configuration

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            require("profiles.stable.ui.intent").show()
        end,
    })
end

return M
