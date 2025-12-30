-- ===============================================================
-- Keymaps
-- ===============================================================
local map = vim.keymap.set -- keymap helper

-- ===============================================================
-- Basic
-- ===============================================================
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" }) -- save buffer
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" }) -- quit window
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all (force)" }) -- quit all without prompts

-- ===============================================================
-- Diagnostics
-- ===============================================================
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics float" }) -- show diagnostic popup
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" }) -- previous diagnostic
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" }) -- next diagnostic

-- ===============================================================
-- Formatting
-- ===============================================================
-- LSP (buffer-local maps are set in lsp.lua on_attach)
-- Format (global fallback)
map("n", "<leader>f", function()
    require("core.format").format_current_buffer() -- format current buffer
end, { desc = "Format buffer" })

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

