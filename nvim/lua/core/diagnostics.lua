local M = {}

function M.setup()
    vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        float = { border = "rounded", source = "if_many" },
        virtual_lines = { underline = true }
    })
end

return M
