-- ===============================================================
-- Treesitter — Parser installation + highlighting/indentation
-- ===============================================================
-- nvim-treesitter is now only a parser installer (main branch).
-- Highlighting and indentation use nvim 0.12 built-in APIs.
-- TSUpdate is handled via PackChanged hook in core/pack.lua.

require("nvim-treesitter").install({
    "lua",
    "typescript",
    "tsx",
    "javascript",
    "json",
    "yaml",
    "toml",
    "go",
    "rust",
    "c_sharp",
    "erlang",
    "bash",
    "html",
    "markdown",
    "markdown_inline",
})

-- Enable treesitter highlighting and indentation for all filetypes
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})
vim.o.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
