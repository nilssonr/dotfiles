-- ===============================================================
-- Formatting
-- ===============================================================
local M = {} -- module table

local function has(cmd)
    return vim.fn.executable(cmd) == 1 -- check if command exists
end

function M.format_current_buffer()
    local ft = vim.bo.filetype -- current buffer filetype

    -- ===========================================================
    -- XML: use xmllint
    -- ===========================================================
    if ft == "xml" then
        if not has("xmllint") then
            vim.notify("xmllint not found on PATH", vim.log.levels.WARN) -- warn and exit
            return
        end

        local buf = vim.api.nvim_get_current_buf() -- current buffer handle
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false) -- buffer contents
        local input = table.concat(lines, "\n") -- join into one string
        local has_decl = input:match("^%s*<%?xml") ~= nil -- detect existing XML declaration

        -- xmllint reads from stdin with "-" and writes formatted XML to stdout
        local result = vim.system({ "xmllint", "--format", "-" }, { stdin = input, text = true }):wait() -- run formatter

        if result.code ~= 0 then
            local msg = (result.stderr and result.stderr ~= "") and result.stderr or "xmllint failed" -- error message
            vim.notify(msg, vim.log.levels.ERROR)
            return
        end

        local out = result.stdout or "" -- formatted output
        -- xmllint typically ends with a newline; split safely
        local new_lines = vim.split(out, "\n", { plain = true }) -- split into lines
        if not has_decl and #new_lines > 0 and new_lines[1]:match("^%s*<%?xml") then
            table.remove(new_lines, 1) -- don't insert declaration when absent
        end
        -- Remove trailing empty line if it's just the final newline
        if #new_lines > 0 and new_lines[#new_lines] == "" then
            table.remove(new_lines, #new_lines) -- drop final empty line
        end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines) -- replace buffer contents
        return
    end

    -- ===========================================================
    -- Default: use LSP formatting if available
    -- ===========================================================
    vim.lsp.buf.format({ async = false, timeout_ms = 5000 }) -- synchronous LSP format
end

return M
