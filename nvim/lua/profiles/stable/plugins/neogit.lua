return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
    },
    keys = {
        {
            "<leader>ng",
            function()
                require("neogit").open()
            end,
            desc = "Neogit",
        },
    },
    config = function()
        require("neogit").setup({
            integrations = {
                diffview = true,
            },
        })
    end,
}
