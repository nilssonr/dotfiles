local M = {}

function M.setup()
    vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        float = { source = "if_many" },
        virtual_lines = { current_line = true }
    })
end

return M
