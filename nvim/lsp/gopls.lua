-- ===============================================================
-- gopls — Go language server
-- ===============================================================
-- Auto-discovered by vim.lsp.enable("gopls").

return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", "go.work", ".git" },
}
