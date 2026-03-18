-- ===============================================================
-- Completion — blink.cmp
-- ===============================================================
-- LSP-only completion with CR to accept, Tab/S-Tab to navigate.

require("blink.cmp").setup({
    -- vim.pack clones main (not a tag), so tell blink which release binary to use
    fuzzy = { prebuilt_binaries = { force_version = "v1.10.1" } },
    keymap = {
        preset = "none",
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
    },
    sources = {
        default = { "lsp" },
    },
    completion = {
        list = {
            selection = {
                preselect = true,
                auto_insert = false,
            },
        },
        menu = {
            winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            draw = {
                columns = {
                    { "label", "label_description", gap = 1 },
                    { "kind" },
                },
            },
        },
        documentation = {
            window = {
                winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
            },
        },
    },
})
