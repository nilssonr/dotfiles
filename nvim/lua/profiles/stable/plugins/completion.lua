return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    config = function()
        local cmp = require("cmp")

        -- Manual trigger (mimics omni-complete)
        vim.keymap.set("i", "<C-x><C-o>", function()
            cmp.complete()
        end, { silent = true })

        cmp.setup({
            preselect = cmp.PreselectMode.Item,
            snippet = {
                expand = function()
                    -- No snippets by design
                end,
            },

            -- Keybindings
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),

            -- Sources (priority order)
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "buffer" },
            }),

            -- No icons — plain text menu
            formatting = {
                format = function(_, item)
                    item.menu = ""
                    return item
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
        })
    end,
}
