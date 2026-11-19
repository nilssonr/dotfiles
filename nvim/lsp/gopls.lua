-- ===============================================================
-- gopls — Go language server
-- ===============================================================
-- Auto-discovered by vim.lsp.enable("gopls").

return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork" },
    -- go.work first so a parent workspace wins over a module's go.mod
    root_markers = { "go.work", "go.mod", ".git" },
}
