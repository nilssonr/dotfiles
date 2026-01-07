-- ===============================================================
-- Keymaps
-- ===============================================================
local map = vim.keymap.set -- keymap helper

-- ===============================================================
-- Basic
-- ===============================================================
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })              -- save buffer
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })               -- quit window
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all (force)" }) -- quit all without prompts

-- ===============================================================
-- Editing
-- ===============================================================
map("x", "x", '"_d', { desc = "Delete without yanking" }) -- visual delete to black hole
map("x", "X", '"_d', { desc = "Delete without yanking" }) -- visual delete to black hole

-- ===============================================================
-- Buffers
-- ===============================================================
map("n", "<leader>bd", "<cmd>bd<cr>")

-- ===============================================================
-- Diagnostics
-- ===============================================================
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics float" }) -- show diagnostic popup
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })           -- previous diagnostic
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })           -- next diagnostic

-- ===============================================================
-- Formatting
-- ===============================================================
-- LSP (buffer-local maps are set in lsp.lua on_attach)
-- Format (global fallback)
map("n", "<leader>f", function()
    require("core.format").format_current_buffer() -- format current buffer
end, { desc = "Format buffer" })

-- ===============================================================
-- LSP (buffer-local)
-- ===============================================================
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf

        if vim.b[bufnr].lsp_keymaps then
            return
        end

        vim.b[bufnr].lsp_keymaps = true

        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) -- buffer-local map helper
        end

        map("n", "gd", vim.lsp.buf.definition, "go to definition")     -- jump to definition
        map("n", "gr", vim.lsp.buf.references, "references")           -- list references
        map("n", "gI", vim.lsp.buf.implementation, "implementations")  -- find implementations
        map("n", "K", vim.lsp.buf.hover, "Hover")                      -- hover documentation
        map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")           -- rename symbol
        map("n", "<leader>la", vim.lsp.buf.code_action, "Code action") -- code actions
        map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })                       -- LSP format current buffer
        end, "Format")
    end,
})

-- ===============================================================
-- Navigation
-- ===============================================================
-- Smart split navigation:
-- 1) Move within Neovim splits if possible
-- 2) Otherwise fall back to tmux pane navigation
local function smart_navigate(dir)
    local cur_win = vim.api.nvim_get_current_win()

    -- Attempt Neovim split navigation
    vim.cmd("wincmd " .. dir)

    -- If we moved, stop here
    if vim.api.nvim_get_current_win() ~= cur_win then
        return
    end

    -- If at edge of Neovim splits, fall back to tmux (if inside tmux)
    if vim.env.TMUX then
        local tmux_dir = ({
            h = "L",
            j = "D",
            k = "U",
            l = "R",
        })[dir]

        if tmux_dir then
            os.execute("tmux select-pane -" .. tmux_dir .. " 2>/dev/null")
        end
    end
end

-- Normal mode
map("n", "<C-h>", function() smart_navigate("h") end, { desc = "Left (vim split, else tmux)" })
map("n", "<C-j>", function() smart_navigate("j") end, { desc = "Down (vim split, else tmux)" })
map("n", "<C-k>", function() smart_navigate("k") end, { desc = "Up (vim split, else tmux)" })
map("n", "<C-l>", function() smart_navigate("l") end, { desc = "Right (vim split, else tmux)" })

-- Terminal mode (exit insert, then navigate)
map("t", "<C-h>", function()
    vim.cmd("stopinsert")
    smart_navigate("h")
end, { desc = "Left (terminal)" })

map("t", "<C-j>", function()
    vim.cmd("stopinsert")
    smart_navigate("j")
end, { desc = "Down (terminal)" })

map("t", "<C-k>", function()
    vim.cmd("stopinsert")
    smart_navigate("k")
end, { desc = "Up (terminal)" })

map("t", "<C-l>", function()
    vim.cmd("stopinsert")
    smart_navigate("l")
end, { desc = "Right (terminal)" })

-- ===============================================================
-- Terminal
-- ===============================================================
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" }) -- exit terminal mode

-- ===============================================================
-- Git
-- ===============================================================
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
