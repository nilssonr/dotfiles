-- ===============================================================
-- LSP Setup
-- ===============================================================
local M = {} -- module table

local function list_package_dirs(root)
    local packages_dir = root .. "/packages"
    local dirs = {}

    local handle = vim.loop.fs_scandir(packages_dir)
    if not handle then
        return dirs
    end

    while true do
        local name, t = vim.loop.fs_scandir_next(handle)
        if not name then
            break
        end
        if t == "directory" then
            table.insert(dirs, packages_dir .. "/" .. name)
        end
    end

    table.sort(dirs)
    return dirs
end

local function angular_probe_locations(root)
    local probes = { root }
    for _, dir in ipairs(list_package_dirs(root)) do
        table.insert(probes, dir)
    end
    return probes
end

function M.setup()
    local util = require("core.util")                                -- shared helpers
    local capabilities = vim.lsp.protocol.make_client_capabilities() -- base lsp capabilities

    -- merge cmp_nvim_lsp capabilities when available
    local ok, cmp = pcall(require, "cmp_nvim_lsp")            -- optional completion integration
    if ok and cmp and type(cmp.default_capabilities) == "function" then
        capabilities = cmp.default_capabilities(capabilities) -- extend capabilities for cmp
    end

    capabilities.textDocument.completion.completionItem.snippetSupport = false -- disable snippet completions

    -- ===========================================================
    -- Server Definitions
    -- ===========================================================
    -- Edit ONE table to add/remove servers
    local servers = {
        gopls = {
            cmd = { "gopls" },                                 -- Go language server
            filetypes = { "go", "gomod", "gowork", "gotmpl" }, -- Go filetypes
        },
        rust_analyzer = {
            cmd = { "rust-analyzer" },                                                    -- Rust language server
            filetypes = { "rust" },                                                       -- Rust filetypes
            root_dir = function(bufnr)
                local fname = vim.api.nvim_buf_get_name(bufnr)                            -- current file path
                local dir = vim.fs.dirname(fname)                                         -- current directory
                local cargo = vim.fs.find("Cargo.toml", { upward = true, path = dir })[1] -- find Cargo.toml
                return cargo and vim.fs.dirname(cargo) or nil                             -- use Cargo root or nil
            end,
        },
        ts_ls = {
            cmd = { "typescript-language-server", "--stdio" },                                -- TypeScript/JS language server
            filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }, -- TS/JS filetypes
        },
        angularls = {
            cmd = function(dispatchers, config)
                local root_dir = config.root_dir or vim.fn.getcwd()

                local probes = angular_probe_locations(root_dir)
                local probe_arg = table.concat(probes, ",")

                local cmd = {
                    "ngserver",
                    "--stdio",
                    "--tsProbeLocations",
                    probe_arg,
                    "--ngProbeLocations",
                    probe_arg,
                }

                return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root_dir })
            end,

            filetypes = { "typescript", "typescriptreact", "html" },
            root_markers = { "angular.json", "project.json" },
            workspace_required = true,
        },
        yamlls = {
            cmd = { "yaml-language-server", "--stdio" }, -- YAML language server
            filetypes = { "yaml", "yml" },               -- YAML filetypes
        },
        taplo = {
            cmd = { "taplo", "lsp", "stdio" }, -- TOML language server
            filetypes = { "toml" },            -- TOML filetypes
        },
        jsonls = {
            cmd = { "vscode-json-languageserver", "--stdio" }, -- JSON language server
            filetypes = { "json", "jsonc" },                   -- JSON filetypes
        },
        bashls = {
            cmd = { "bash-language-server", "start" }, -- Bash language server
            filetypes = { "sh", "bash", "zsh" },        -- Shell filetypes
        },
        lua_ls = {
            cmd = { "lua-language-server" }, -- Lua language server
            filetypes = { "lua" },           -- Lua filetypes
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
                            vim.env.VIMRUNTIME,  -- add runtime to library
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

        if type(cfg.cmd) == "table" and cfg.cmd[1] and not util.executable(cfg.cmd[1]) then
            -- Optional warning; keep quiet by default
            -- util.warn(("Missing LSP binary for %s: %s"):format(name, cfg.cmd[1]))
        end

        vim.lsp.config[name] = cfg -- register with Neovim LSP config table
    end

    -- Enable all configured servers
    vim.lsp.enable(vim.tbl_keys(servers)) -- activate servers
end

return M
