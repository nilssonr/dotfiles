-- ===============================================================
-- ts_ls — TypeScript/JavaScript language server
-- ===============================================================

return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_markers = { "tsconfig.json", "package.json", ".git" },
}
