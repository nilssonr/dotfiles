vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.opt.wrap = false
vim.opt.scrolloff = 8

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

-- Do not force indentation width here; EditorConfig will set per-buffer.
-- Keep conservative defaults.
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- No “cute” conceal/italics-y behavior
vim.opt.conceallevel = 0

vim.opt.clipboard = "unnamedplus"

vim.opt.completeopt = { "menu", "menuone", "noselect" }
