-- ===============================================================
-- angularls — Angular language server
-- ===============================================================
-- Uses an RPC function for cmd to inject monorepo probe locations.
-- workspace_required = true prevents activation outside Angular projects.

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

return {
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
}
