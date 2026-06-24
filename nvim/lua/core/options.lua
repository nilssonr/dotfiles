-- ===============================================================
-- Options — Editor settings and statusline
-- ===============================================================
-- UI preferences, search, timing, indentation, folding, and a custom
-- statusline with git branch + dirty indicator via gitsigns.

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = true
vim.opt.scrolloff = 8

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Timing
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

-- Keep swap files out of project trees
local swap_dir = vim.fn.expand("~/.nvim-swp")
if vim.fn.isdirectory(swap_dir) == 0 then
    vim.fn.mkdir(swap_dir, "p")
end
vim.opt.directory = { swap_dir .. "//" }

-- Persistent undo — survives restarts, kept out of project trees
local undo_dir = vim.fn.expand("~/.nvim-undo")
if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, "p")
end
vim.opt.undofile = true
vim.opt.undodir = { undo_dir }

-- Indentation — conservative defaults; EditorConfig sets per-buffer
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Visuals
vim.opt.conceallevel = 2 -- render-markdown.nvim needs >= 1
vim.opt.foldmethod = "expr" -- use Tree-sitter for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Tree-sitter fold expression
vim.opt.foldlevel = 99 -- start unfolded
vim.opt.foldlevelstart = 99 -- open folds on buffer read
vim.opt.clipboard = "unnamedplus"

-- Global floating window border
vim.o.winborder = "rounded"

-- Statusline: branch + dirty indicator, sourced from gitsigns.
-- Dirty reflects the *current file's* working-tree changes (added/changed/removed).
-- The %{...} expression re-evaluates on every redraw, so no refresh autocmd is needed.
function _G.statusline_git()
    local dict = vim.b.gitsigns_status_dict
    if not dict or not dict.head or dict.head == "" then return "" end
    local dirty = (dict.added or 0) + (dict.changed or 0) + (dict.removed or 0) > 0
    return dict.head .. (dirty and "*" or "")
end

vim.opt.statusline = table.concat({
    "%#StatusLineFile# %f",                              -- filename
    "%#StatusLineModified#%m",                           -- modified flag
    "%#StatusLine#%r%h%w",                               -- readonly/help/preview
    "%=",                                                -- right align
    "%#StatusLineGit#%{v:lua.statusline_git()}",         -- git branch + dirty indicator
    "%#StatusLineSep# │ ",                               -- separator
    "%#StatusLinePos#%l:%c ",                            -- line:col
})
