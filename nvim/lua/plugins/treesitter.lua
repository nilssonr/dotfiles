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

-- zsh has no parser of its own; the bash parser covers most of it
vim.treesitter.language.register("bash", "zsh")

-- Enable treesitter highlighting and indentation for all filetypes.
-- indentexpr is set per buffer: a global value is overridden by the
-- runtime indent/*.vim scripts for almost every language.
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
