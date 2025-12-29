local M = {}

local function has(cmd)
    return vim.fn.executable(cmd) == 1
end

function M.format_current_buffer()
    local ft = vim.bo.filetype

    -- XML: use xmllint
    if ft == "xml" then
        if not has("xmllint") then
            vim.notify("xmllint not found on PATH", vim.log.levels.WARN)
            return
        end

        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local input = table.concat(lines, "\n")

        -- xmllint reads from stdin with "-" and writes formatted XML to stdout
        local result = vim.system({ "xmllint", "--format", "-" }, { stdin = input, text = true }):wait()

        if result.code ~= 0 then
            local msg = (result.stderr and result.stderr ~= "") and result.stderr or "xmllint failed"
            vim.notify(msg, vim.log.levels.ERROR)
            return
        end

        local out = result.stdout or ""
        -- xmllint typically ends with a newline; split safely
        local new_lines = vim.split(out, "\n", { plain = true })
        -- Remove trailing empty line if it’s just the final newline
        if #new_lines > 0 and new_lines[#new_lines] == "" then
            table.remove(new_lines, #new_lines)
        end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
        return
    end

    -- Default: use LSP formatting if available
    vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
end

return M
