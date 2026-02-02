local M = {}

function M.setup()
    require("core.options")
    require("core.keymaps")
    require("core.autocmds")
    require("core.diagnostics").setup()

    require("core.lazy").setup({
        { import = "profiles.stable.plugins" },
    })

    require("core.roslyn").setup()
    require("core.lsp").setup()

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            require("profiles.stable.ui.intent").show()
        end,
    })
end

return M
