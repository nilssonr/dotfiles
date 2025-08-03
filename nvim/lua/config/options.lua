local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "" -- disable mouse
opt.clipboard = "unnamedplus"

-- Indentation: 2 spaces, no tabs
opt.tabstop = 2        -- Number of spaces tabs count for
opt.shiftwidth = 2     -- Number of spaces for each indent
opt.expandtab = true   -- Convert tabs to spaces
opt.smartindent = true -- Smart autoindenting

opt.wrap = false       -- ⛔ Do not wrap long lines
opt.splitright = true
opt.splitbelow = true

opt.winborder = 'rounded'
opt.laststatus = 3

opt.mousescroll = "ver:0,hor:0"
