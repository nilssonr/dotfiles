local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all (force)" })
map("n", "<leader>ni", "<cmd>Neorg index<cr>", { desc = "Neorg index" })

map("x", "x", '"_d', { desc = "Delete without yanking" })
map("x", "X", '"_d', { desc = "Delete without yanking" })

map("n", "<leader>bd", "<cmd>bd<cr>")

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics float" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

map("n", "<leader>f", function()
    require("core.format").format_current_buffer()
end, { desc = "Format buffer" })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf

        if vim.b[bufnr].lsp_keymaps then
            return
        end

        vim.b[bufnr].lsp_keymaps = true

        local bmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        bmap("n", "gd", vim.lsp.buf.definition, "go to definition")
        bmap("n", "gr", vim.lsp.buf.references, "references")
        bmap("n", "gI", vim.lsp.buf.implementation, "implementations")
        bmap("n", "K", vim.lsp.buf.hover, "Hover")
        bmap("i", "<C-k>", vim.lsp.buf.signature_help, "signature help")
        bmap("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
        bmap("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
    end,
})

map("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })

local function open_lazygit()
    if vim.fn.executable("lazygit") ~= 1 then
        vim.notify("lazygit not found in PATH", vim.log.levels.ERROR)
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"

    local width = math.max(20, math.floor(vim.o.columns * 0.8))
    local height = math.max(10, math.floor(vim.o.lines * 0.7))
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_create_autocmd("TermClose", {
        buffer = buf,
        once = true,
        callback = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end,
    })

    vim.fn.termopen("lazygit")
    vim.cmd("startinsert")
end

map("n", "<leader>lg", open_lazygit, { desc = "Lazygit" })
