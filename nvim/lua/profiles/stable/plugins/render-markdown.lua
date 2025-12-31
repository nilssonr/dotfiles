return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons", -- optional, but nice
    },
    opts = {
        -- defaults are already pretty good; keep minimal
    },
    keys = {
        { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: Toggle render" },
    },
}
