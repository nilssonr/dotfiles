vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.opt.wrap = false
vim.opt.scrolloff = 8

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

local swap_dir = vim.fn.expand("~/.nvim-swp")
if vim.fn.isdirectory(swap_dir) == 0 then
    vim.fn.mkdir(swap_dir, "p")
end
vim.opt.directory = { swap_dir .. "//" }

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.conceallevel = 0

vim.opt.clipboard = "unnamedplus"

vim.opt.completeopt = { "menu", "menuone", "noinsert" }
