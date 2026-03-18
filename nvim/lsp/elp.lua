-- ===============================================================
-- elp — Erlang Language Platform (WhatsApp/Meta)
-- ===============================================================

return {
    cmd = { "elp", "server" },
    cmd_env = {
        ELP_EQWALIZER_PATH = vim.fn.expand("~/.local/share/eqwalizer.jar"),
    },
    filetypes = { "erlang" },
    root_markers = { "rebar.config", "erlang.mk", ".git" },
    settings = {
        elp = {
            diagnostics = {
                disabled = {},
            },
        },
    },
}
