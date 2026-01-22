-- ===============================================================
-- Completion (nvim-cmp)
-- ===============================================================
return {
    "hrsh7th/nvim-cmp",         -- completion engine
    event = "InsertEnter",      -- lazy-load on first insert
    dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- LSP completion source
        "hrsh7th/cmp-buffer",   -- buffer completion source
        "hrsh7th/cmp-path",     -- path completion source
    },
    config = function()
        local cmp = require("cmp") -- completion module


        vim.keymap.set("i", "<C-x><C-o>", function()
            cmp.complete()
        end, { silent = true })

        cmp.setup({
            preselect = cmp.PreselectMode.Item, -- visually selects the first item in the list
            snippet = {
                expand = function()
                    -- No snippets by design
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(), -- trigger completion
                ["<C-e>"] = cmp.mapping.abort(),        -- close completion
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true }) -- confirm selected item
                    else
                        fallback()                     -- default Enter behavior
                    end
                end, { "i", "s" }),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item() -- next completion item
                    else
                        fallback()             -- default Tab behavior
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item() -- previous completion item
                    else
                        fallback()             -- default Shift-Tab behavior
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" }, -- LSP source
                { name = "path" },     -- filesystem paths
                { name = "buffer" },   -- buffer words
            }),
            formatting = {
                format = function(_, item)
                    -- No icons
                    item.menu = "" -- empty menu column
                    return item
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),    -- bordered completion
                documentation = cmp.config.window.bordered(), -- bordered docs
            },
        })
    end,
}
