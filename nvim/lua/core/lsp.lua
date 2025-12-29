-- ===============================================================
-- LSP Setup
-- ===============================================================
local M = {} -- module table

function M.setup()
    local util = require("core.util") -- shared helpers
    local capabilities = vim.lsp.protocol.make_client_capabilities() -- base LSP capabilities

    -- Merge cmp_nvim_lsp capabilities when available
    local ok, cmp = pcall(require, "cmp_nvim_lsp") -- optional completion integration
    if ok and cmp and type(cmp.default_capabilities) == "function" then
        capabilities = cmp.default_capabilities(capabilities) -- extend capabilities for cmp
    end

    capabilities.textDocument.completion.completionItem.snippetSupport = false -- disable snippet completions

    -- ===========================================================
    -- LSP Keymaps (buffer-local)
    -- ===========================================================
    local function on_attach(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) -- buffer-local map helper
        end

        map("n", "gd", vim.lsp.buf.definition, "Go to definition") -- jump to definition
        map("n", "gr", vim.lsp.buf.references, "References") -- list references
        map("n", "K", vim.lsp.buf.hover, "Hover") -- hover documentation
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename") -- rename symbol
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action") -- code actions
        map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true }) -- LSP format current buffer
        end, "Format")
    end

    -- ===========================================================
    -- Server Definitions
    -- ===========================================================
    -- Edit ONE table to add/remove servers
    local servers = {
        gopls = {
            cmd = { "gopls" }, -- Go language server
            filetypes = { "go", "gomod", "gowork", "gotmpl" }, -- Go filetypes
        },
        rust_analyzer = {
            cmd = { "rust-analyzer" }, -- Rust language server
            filetypes = { "rust" }, -- Rust filetypes
            root_dir = function(bufnr)
                local fname = vim.api.nvim_buf_get_name(bufnr) -- current file path
                local dir = vim.fs.dirname(fname) -- current directory
                local cargo = vim.fs.find("Cargo.toml", { upward = true, path = dir })[1] -- find Cargo.toml
                return cargo and vim.fs.dirname(cargo) or nil -- use Cargo root or nil
            end,
        },
        ts_ls = {
            cmd = { "typescript-language-server", "--stdio" }, -- TypeScript/JS language server
            filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }, -- TS/JS filetypes
        },
        yamlls = {
            cmd = { "yaml-language-server", "--stdio" }, -- YAML language server
            filetypes = { "yaml", "yml" }, -- YAML filetypes
        },
        taplo = {
            cmd = { "taplo", "lsp", "stdio" }, -- TOML language server
            filetypes = { "toml" }, -- TOML filetypes
        },
        jsonls = {
            cmd = { "vscode-json-languageserver", "--stdio" }, -- JSON language server
            filetypes = { "json", "jsonc" }, -- JSON filetypes
        },
        lua_ls = {
            cmd = { "lua-language-server" }, -- Lua language server
            filetypes = { "lua" }, -- Lua filetypes
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT", -- Neovim Lua runtime
                    },
                    diagnostics = {
                        globals = { "vim" }, -- recognize Neovim globals
                    },
                    workspace = {
                        library = {
                            vim.env.VIMRUNTIME, -- add runtime to library
                        },
                        checkThirdParty = false, -- disable third-party checks
                    },
                    telemetry = {
                        enable = false, -- disable telemetry
                    },
                },
            },
        },
    }

    -- ===========================================================
    -- Register Servers
    -- ===========================================================
    for name, cfg in pairs(servers) do
        cfg.capabilities = capabilities -- apply shared capabilities
        cfg.on_attach = on_attach -- attach keymaps

        if cfg.cmd and cfg.cmd[1] and not util.executable(cfg.cmd[1]) then
            -- Optional warning; keep quiet by default
            -- util.warn(("Missing LSP binary for %s: %s"):format(name, cfg.cmd[1]))
        end

        vim.lsp.config[name] = cfg -- register with Neovim LSP config table
    end

    -- Enable all configured servers
    vim.lsp.enable(vim.tbl_keys(servers)) -- activate servers
end

return M
