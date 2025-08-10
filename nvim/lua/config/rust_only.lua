-- lua/config/rust_only.lua
-- Always use rustaceanvim's rust-analyzer. Block any other setup and kill duplicates.

local M = {}

-- 1) Block vanilla lspconfig rust_analyzer.setup() anywhere in your config/plugins.
function M.block_vanilla_ra()
    local function patch()
        local ok, lspconfig = pcall(require, "lspconfig")
        if not ok then return end
        local ra = rawget(lspconfig, "rust_analyzer")
        if not ra or type(ra.setup) ~= "function" then return end

        local old = ra.setup
        ra.setup = function(...)
            vim.notify(
                "Blocked lspconfig.rust_analyzer.setup(): rustaceanvim manages Rust LSP",
                vim.log.levels.WARN
            )
            -- Do nothing; rustaceanvim will handle rust-analyzer.
            return nil
        end
    end

    -- Try immediately, and again when lspconfig loads (if not yet available)
    pcall(patch)
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function() pcall(patch) end,
    })
end

-- 2) Order-agnostic dedupe: keep rustaceanvim client ("rust-analyzer"), stop all others.
function M.dedupe_on_attach()
    local grp = vim.api.nvim_create_augroup("RustOnlyRustaceanvim", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = grp,
        callback = function(args)
            local bufnr = args.buf
            if vim.bo[bufnr].filetype ~= "rust" then return end

            -- collect all rust analyzer clients attached to this buffer
            local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
            local keep -- the rustaceanvim client (hyphenated name)
            for _, c in ipairs(clients) do
                if c.name == "rust-analyzer" then
                    keep = c
                    break
                end
            end

            -- If the preferred client doesn't exist yet, do nothing (let it attach first).
            if not keep then return end

            -- Stop every other rust analyzer client
            for _, c in ipairs(clients) do
                if (c.name == "rust_analyzer" or c.name == "rust-analyzer") and c.id ~= keep.id then
                    c.stop()
                end
            end
        end,
    })
end

function M.setup()
    M.block_vanilla_ra()
    M.dedupe_on_attach()
end

return M
