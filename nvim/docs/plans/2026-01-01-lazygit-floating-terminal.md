# Lazygit Floating Terminal Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a `<leader>lg` mapping that opens lazygit inside a floating terminal window in Neovim.

**Architecture:** Implement a local helper in `core.keymaps` that creates a scratch buffer, opens a centered floating window, and launches `lazygit` with `termopen`. Clean up the window on terminal close and notify if lazygit is missing.

**Tech Stack:** Neovim Lua config (`vim.api`, `vim.fn.termopen`, `vim.notify`).

### Task 1: Lazygit Floating Terminal Mapping

**Files:**
- Modify: `nvim/lua/core/keymaps.lua`

**Step 1: Write minimal implementation**

```lua
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
```

**Step 2: Manual verification**

- Launch Neovim, press `<leader>lg`, confirm lazygit opens in a floating window.
- Press `q` inside lazygit and confirm the window closes cleanly.
- Temporarily rename `lazygit` to confirm the error notification appears (optional).

**Step 3: Commit**

```bash
git add nvim/tests/lazygit_keymap.lua nvim/lua/core/keymaps.lua
git commit -m "feat: add lazygit floating terminal keymap"
```
