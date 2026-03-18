-- ===============================================================
-- lua_ls — Lua language server
-- ===============================================================
-- Configured for Neovim plugin development: LuaJIT runtime, vim global,
-- workspace library pointed at VIMRUNTIME, telemetry disabled.

return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".git" },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
}
