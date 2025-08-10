local lspconfig = require("lspconfig")

local capabilities = (function()
    local ok, cmp = pcall(require, "cmp_nvim_lsp")
    if ok then return cmp.default_capabilities() end
    return vim.lsp.protocol.make_client_capabilities()
end)()

local servers = { "lua_ls", "gopls" }

for _, name in ipairs(servers) do
    -- rust_analyzer is handled by rustaceanvim, so don’t set it up here.
    if name ~= "rust_analyzer" then
        local ok, opts = pcall(require, "lsp." .. name)
        if not ok then opts = {} end
        opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
        if lspconfig[name] then
            lspconfig[name].setup(opts)
        else
            vim.notify("lspconfig server not found: " .. name, vim.log.levels.WARN)
        end
    end
end
