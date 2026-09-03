-- ===============================================================
-- elp — Erlang Language Platform (WhatsApp/Meta)
-- ===============================================================

-- ELP_EQWALIZER_PATH is inherited from the shell, where .zshrc exports it
-- only while the pre-extracted jar matches the installed elp (see
-- elp-eqwalizer-sync there). Forcing it here would pin a jar that goes
-- stale on every ELP upgrade and break eqWAlizer in the editor.
return {
    cmd = { "elp", "server" },
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
