-- ===============================================================
-- rust-analyzer — Rust language server
-- ===============================================================
-- root_markers replaces the custom root_dir function from the old config.
-- vim.lsp walks upward from the buffer looking for Cargo.toml automatically.

return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
}
