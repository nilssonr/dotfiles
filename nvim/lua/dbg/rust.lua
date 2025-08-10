local M = {}

local function os_liblldb(base)
    local sys = (vim.uv or vim.loop).os_uname().sysname
    if sys == "Darwin" then
        return base .. "lldb/lib/liblldb.dylib"
    elseif sys == "Windows_NT" then
        return base .. "lldb/bin/liblldb.dll"
    else
        return base .. "lldb/lib/liblldb.so"
    end
end

-- Fallback: look in stdpath for Mason’s codelldb
local function guess_paths_from_stdpath()
    local ext = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
    local codelldb = ext .. "adapter/codelldb"
    if (vim.uv or vim.loop).fs_stat(codelldb) then
        return codelldb, os_liblldb(ext)
    end
end

local function mason_codelldb_paths()
    local ok, registry = pcall(require, "mason-registry")
    if not ok then
        return guess_paths_from_stdpath()
    end
    if not registry.has_package("codelldb") then
        return guess_paths_from_stdpath()
    end

    local pkg = registry.get_package("codelldb")
    -- Be resilient to Mason API changes
    local install
    if pkg and pkg.get_install_path then
        install = pkg:get_install_path()
    elseif pkg and pkg.install_path then
        install = pkg.install_path
    end
    if not install then
        return guess_paths_from_stdpath()
    end

    local ext = install .. "/extension/"
    local codelldb = ext .. "adapter/codelldb"
    if (vim.uv or vim.loop).fs_stat(codelldb) then
        return codelldb, os_liblldb(ext)
    end
end

function M.adapter()
    local codelldb, liblldb = mason_codelldb_paths()
    if not codelldb then
        vim.schedule(function()
            vim.notify("codelldb not found. Run :MasonInstall codelldb", vim.log.levels.WARN)
        end)
        return nil
    end

    local ok, cfg = pcall(require, "rustaceanvim.config")
    if not ok then
        return nil
    end
    return cfg.get_codelldb_adapter(codelldb, liblldb)
end

return M
