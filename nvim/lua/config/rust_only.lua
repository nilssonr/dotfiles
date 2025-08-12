-- Always use rustaceanvim's rust-analyzer. Block others and dedupe on attach.

local M = {}

-- 1) Block vanilla lspconfig rust_analyzer.setup() globally
function M.block_vanilla_ra()
    local function patch()
        local ok, lspconfig = pcall(require, "lspconfig")
        if not ok then return end
        local ra = rawget(lspconfig, "rust_analyzer")
        if not ra or type(ra.setup) ~= "function" then return end

        -- Already patched? bail.
        if ra._rustaceanvim_blocked then return end
        ra._rustaceanvim_blocked = true

        local old = ra.setup
        ra.setup = function(...)
            vim.notify(
                "Blocked lspconfig.rust_analyzer.setup(): rustaceanvim manages Rust LSP",
                vim.log.levels.WARN
            )
            return nil
        end
    end

    -- Try now and also after lazy plugins load
    pcall(patch)
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function() pcall(patch) end,
    })
end

-- 2) Dedupe: keep rustaceanvim client ("rust-analyzer"), stop others, regardless of order
function M.dedupe_on_attach()
    local grp = vim.api.nvim_create_augroup("RustOnlyRustaceanvim", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = grp,
        callback = function(args)
            local bufnr = args.buf
            if vim.bo[bufnr].filetype ~= "rust" then return end

            local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
            -- prefer the rustaceanvim client (hyphenated name)
            local keep
            for _, c in ipairs(clients) do
                if c.name == "rust-analyzer" then
                    keep = c
                    break
                end
            end
            -- if rustaceanvim hasn't attached yet, wait (we'll run again on next attach)
            if not keep then return end

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
