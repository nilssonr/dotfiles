-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
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

-- Indentation — conservative defaults; EditorConfig sets per-buffer
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Visuals
vim.opt.conceallevel = 0 -- disable conceal (no italics/fancy rendering)
vim.opt.foldmethod = "expr" -- use Tree-sitter for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Tree-sitter fold expression
vim.opt.foldlevel = 99 -- start unfolded
vim.opt.foldlevelstart = 99 -- open folds on buffer read
vim.opt.clipboard = "unnamedplus"

-- noinsert ensures the first completion item is pre-selected
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
