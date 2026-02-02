-- ===============================================================
-- UI
-- ===============================================================
vim.opt.number = true         -- show absolute line numbers
vim.opt.relativenumber = true -- show relative line numbers

vim.opt.termguicolors = true  -- enable 24-bit color
vim.opt.signcolumn = "yes"    -- always show sign column

vim.opt.wrap = false          -- disable line wrapping
vim.opt.scrolloff = 8         -- keep 8 lines visible around cursor

-- ===============================================================
-- Search
-- ===============================================================
vim.opt.ignorecase = true -- case-insensitive search by default
vim.opt.smartcase = true  -- case-sensitive if uppercase in query

-- ===============================================================
-- Timing
-- ===============================================================
vim.opt.updatetime = 250 -- faster CursorHold and diagnostics
vim.opt.timeoutlen = 400 -- key sequence timeout

-- ===============================================================
-- Swap
-- ===============================================================
local swap_dir = vim.fn.expand("~/.nvim-swp")
if vim.fn.isdirectory(swap_dir) == 0 then
    vim.fn.mkdir(swap_dir, "p")
end
vim.opt.directory = { swap_dir .. "//" } -- keep swap files out of project trees

-- ===============================================================
-- Indentation
-- ===============================================================
-- Do not force indentation width here; EditorConfig will set per-buffer.
-- Keep conservative defaults.
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4   -- indentation width
vim.opt.tabstop = 4      -- tab display width

-- ===============================================================
-- Visuals
-- ===============================================================
vim.opt.conceallevel = 0 -- disable conceal (no italics/fancy rendering)
vim.opt.foldmethod = "expr" -- use Tree-sitter for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Tree-sitter fold expression
vim.opt.foldlevel = 99 -- start unfolded
vim.opt.foldlevelstart = 99 -- open folds on buffer read

-- ===============================================================
-- Clipboard
-- ===============================================================
vim.opt.clipboard = "unnamedplus" -- use system clipboard

-- ===============================================================
-- Completion
-- ===============================================================
vim.schedule(function()
    vim.opt.completeopt = { "menu", "menuone", "noselect" } -- completion menu behavior
end)
