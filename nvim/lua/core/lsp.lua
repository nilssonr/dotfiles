local M = {}

function M.setup()
    local util = require("core.util")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local ok, cmp = pcall(require, "cmp_nvim_lsp")
    if ok and cmp and type(cmp.default_capabilities) == "function" then
        capabilities = cmp.default_capabilities(capabilities)
    end

    capabilities.textDocument.completion.completionItem.snippetSupport = false

    local function on_attach(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, "Format")
    end

    -- Edit ONE table to add/remove servers
    local servers = {
        gopls = {
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
        },
        rust_analyzer = {
            cmd = { "rust-analyzer" },
            filetypes = { "rust" },
            root_dir = function(bufnr)
                local fname = vim.api.nvim_buf_get_name(bufnr)
                local dir = vim.fs.dirname(fname)
                local cargo = vim.fs.find("Cargo.toml", { upward = true, path = dir })[1]
                return cargo and vim.fs.dirname(cargo) or nil
            end,
        },
        ts_ls = {
            cmd = { "typescript-language-server", "--stdio" },
            filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        },
        yamlls = {
            cmd = { "yaml-language-server", "--stdio" },
            filetypes = { "yaml", "yml" },
        },
        taplo = {
            cmd = { "taplo", "lsp", "stdio" },
            filetypes = { "toml" },
        },
        jsonls = {
            cmd = { "vscode-json-languageserver", "--stdio" },
            filetypes = { "json", "jsonc" },
        },
        lua_ls = {
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = {
                            vim.env.VIMRUNTIME,
                        },
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        },
    }

    -- Define configs
    for name, cfg in pairs(servers) do
        cfg.capabilities = capabilities
        cfg.on_attach = on_attach

        if cfg.cmd and cfg.cmd[1] and not util.executable(cfg.cmd[1]) then
            -- Optional warning; keep quiet by default
            -- util.warn(("Missing LSP binary for %s: %s"):format(name, cfg.cmd[1]))
        end

        vim.lsp.config[name] = cfg
    end

    -- Enable all configured servers
    vim.lsp.enable(vim.tbl_keys(servers))
end

return M
