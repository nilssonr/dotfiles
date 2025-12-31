local M = {}

function M.show()
    if vim.fn.argc() > 0 then
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = true

    local text = "What are you here to do?"

    -- Compute horizontal padding
    local win_width = vim.api.nvim_win_get_width(0)
    local pad = math.max(0, math.floor((win_width - #text) / 2))
    local line = string.rep(" ", pad) .. text

    -- Vertical centering: empty lines above and below
    local win_height = vim.api.nvim_win_get_height(0)
    local top_pad = math.floor(win_height / 2) - 1

    local lines = {}
    for _ = 1, top_pad do
        table.insert(lines, "")
    end
    table.insert(lines, line)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false

    vim.api.nvim_set_current_buf(buf)

    vim.cmd("setlocal nonumber norelativenumber")
    vim.cmd("setlocal nocursorline")
    vim.cmd("setlocal signcolumn=no")
    vim.cmd("setlocal foldcolumn=0")

    -- Remove cursor distraction
    vim.cmd("normal! gg")

    vim.api.nvim_create_autocmd(
        { "BufRead", "BufNewFile", "InsertEnter" },
        {
            once = true,
            callback = function()
                if vim.api.nvim_buf_is_valid(buf) then
                    vim.api.nvim_buf_delete(buf, { force = true })
                end
            end,
        }
    )
end

return M
