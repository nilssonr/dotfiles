local M = {}

function M.setup()
    -- Core editor behavior first
    require("core.options")
    require("core.keymaps")
    require("core.autocmds")
    require("core.diagnostics").setup()

    -- Load plugins for this profile
    require("core.lazy").setup({
        { import = "profiles.stable.plugins" },
    })

    require("core.roslyn").setup()

    -- LSP after plugins are available (cmp_nvim_lsp capabilities, etc.)
    require("core.lsp").setup()
end

return M
