local M = {}

function M.setup()
  vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    severity_sort = true,
    update_in_insert = false,
    float = { border = "rounded", source = "if_many" },
  })
end

return M
