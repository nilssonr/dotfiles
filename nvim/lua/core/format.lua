local M = {}

local function has(cmd)
    return vim.fn.executable(cmd) == 1
end

function M.format_current_buffer()
    local ft = vim.bo.filetype

    if ft == "xml" then
        if not has("xmllint") then
            vim.notify("xmllint not found on PATH", vim.log.levels.WARN)
            return
        end

        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local input = table.concat(lines, "\n")
        local has_decl = input:match("^%s*<%?xml") ~= nil

        local result = vim.system({ "xmllint", "--format", "-" }, { stdin = input, text = true }):wait()

        if result.code ~= 0 then
            local msg = (result.stderr and result.stderr ~= "") and result.stderr or "xmllint failed"
            vim.notify(msg, vim.log.levels.ERROR)
            return
        end

        local out = result.stdout or ""
        local new_lines = vim.split(out, "\n", { plain = true })
        if not has_decl and #new_lines > 0 and new_lines[1]:match("^%s*<%?xml") then
            table.remove(new_lines, 1)
        end
        if #new_lines > 0 and new_lines[#new_lines] == "" then
            table.remove(new_lines, #new_lines)
        end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
        return
    end

    vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
end

return M
