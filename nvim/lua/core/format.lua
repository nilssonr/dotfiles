-- ===============================================================
-- Format — Single entry point for buffer formatting
-- ===============================================================
-- Everything routes through conform (formatter first, LSP fallback).
-- XML uses the custom "xmllint_nodecl" conform formatter, built on
-- M.xmllint below; Erlang uses conform's built-in erlfmt.

local M = {}

--- Run xmllint --format on a list of lines. Does not add an XML
--- declaration when the input had none.
---@param lines string[]
---@return string[]|nil new_lines
---@return string|nil err
function M.xmllint(lines)
    if vim.fn.executable("xmllint") ~= 1 then
        return nil, "xmllint not found on PATH"
    end

    local input = table.concat(lines, "\n")
    local has_decl = input:match("^%s*<%?xml") ~= nil

    local result = vim.system({ "xmllint", "--format", "-" }, { stdin = input, text = true }):wait()
    if result.code ~= 0 then
        return nil, (result.stderr and result.stderr ~= "") and result.stderr or "xmllint failed"
    end

    local new_lines = vim.split(result.stdout or "", "\n", { plain = true })
    if not has_decl and #new_lines > 0 and new_lines[1]:match("^%s*<%?xml") then
        table.remove(new_lines, 1)
    end
    if #new_lines > 0 and new_lines[#new_lines] == "" then
        table.remove(new_lines, #new_lines)
    end
    return new_lines, nil
end

function M.format_current_buffer()
    -- conform loads in the deferred group; before that, format via LSP.
    local ok, conform = pcall(require, "conform")
    if ok then
        conform.format({ async = false, timeout_ms = 5000, lsp_format = "fallback" })
    else
        vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
    end
end

return M
