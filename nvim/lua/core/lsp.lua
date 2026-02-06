local M = {}

-- Scan monorepo packages/ for Angular probe locations
local function list_package_dirs(root)
    local packages_dir = root .. "/packages"
    local dirs = {}

    local handle = vim.uv.fs_scandir(packages_dir)
    if not handle then
        return dirs
    end

    while true do
        local name, t = vim.uv.fs_scandir_next(handle)
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
    local util = require("core.util")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Merge blink.cmp capabilities when available
    local ok, blink = pcall(require, "blink.cmp")
    if ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
    end

    -- No snippets by design
    capabilities.textDocument.completion.completionItem.snippetSupport = false

    -- Server definitions — edit this table to add/remove servers
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
            cmd = { "yaml-language-server", "--stdio" },
            filetypes = { "yaml", "yml" },
        },
        taplo = {
            cmd = { "taplo", "lsp", "stdio" },
            filetypes = { "toml" },
        },
        jsonls = {
            cmd = { "vscode-json-language-server", "--stdio" },
            filetypes = { "json", "jsonc" },
            settings = {
                json = {
                    format = { enable = true },
                    validate = { enable = true },
                },
            },
        },
        bashls = {
            cmd = { "bash-language-server", "start" },
            filetypes = { "sh", "bash", "zsh" },
        },
        lua_ls = {
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
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
        },
    }

    for name, cfg in pairs(servers) do
        cfg.capabilities = capabilities

        if type(cfg.cmd) == "table" and cfg.cmd[1] and not util.executable(cfg.cmd[1]) then
            -- Silently skip missing binaries
        end

        vim.lsp.config[name] = cfg
    end

    vim.lsp.enable(vim.tbl_keys(servers))
end

return M
