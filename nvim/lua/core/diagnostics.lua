-- ===============================================================
-- Diagnostics
-- ===============================================================
local M = {} -- module table

function M.setup()
  vim.diagnostic.config({
    virtual_text = true, -- show diagnostics inline
    underline = true, -- underline problematic text
    severity_sort = true, -- sort diagnostics by severity
    update_in_insert = false, -- don't update while inserting
    float = { border = "rounded", source = "if_many" }, -- floating window style
  })
end

return M
