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

-- Statusline: repo-level dirty check (cached)
_G.statusline_git_dirty = false

local function update_git_dirty()
    vim.fn.jobstart({ "git", "status", "--porcelain" }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            _G.statusline_git_dirty = data and #data > 1 or (data[1] and data[1] ~= "")
            vim.cmd("redrawstatus")
        end,
    })
end

-- Update on save, focus, and directory change
vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "DirChanged" }, {
    callback = update_git_dirty,
})
vim.defer_fn(update_git_dirty, 100)  -- initial check

function _G.statusline_git()
    local head = vim.b.gitsigns_head
    if not head or head == "" then return "" end
    return head .. (_G.statusline_git_dirty and "*" or "")
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
