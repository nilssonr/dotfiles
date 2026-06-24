-- ===============================================================
-- Conform — Formatter engine with LSP fallback
-- ===============================================================
-- Routes file-specific formatters (prettier/stylua/goimports) and falls
-- back to LSP formatting when no formatter is configured or installed.
-- core/format.lua is the single entry point (format-on-save + <leader>cf);
-- conform's own format-on-save is intentionally NOT enabled here.
-- XML/Erlang keep their bespoke handling in core/format.lua.

local prettier = { "prettierd", "prettier", stop_after_first = true }

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        javascript = prettier,
        javascriptreact = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        json = prettier,
        jsonc = prettier,
        yaml = prettier,
        html = prettier,
        css = prettier,
        markdown = prettier,
    },
    -- Calls that omit opts (and the core/format.lua fallback) still try a
    -- formatter first, then LSP if none is available/installed.
    default_format_opts = {
        lsp_format = "fallback",
    },
})
