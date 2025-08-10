return {
    {
        "mrcjkb/rustaceanvim",
        version = "^6",
        ft = { "rust" },
        init = function()
            -- Try to get the codelldb adapter without forcing rustaceanvim to load globally
            local adapter = nil
            local ok, rust_dbg = pcall(require, "dbg.rust")
            if ok and type(rust_dbg.adapter) == "function" then
                adapter = rust_dbg.adapter()
            end

            vim.g.rustaceanvim = {
                server = {
                    settings = {
                        ["rust-analyzer"] = {
                            -- Correct, modern settings:
                            checkOnSave = true,
                            check = { command = "clippy" },
                            inlayHints = { locationLinks = false },
                        },
                    },
                },
                dap = { adapter = adapter },
            }
        end,
    },
}
