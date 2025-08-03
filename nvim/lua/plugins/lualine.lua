return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto",
        icons_enabled = false,
        component_separators = { left = "", right = ""},
        section_separators = { left = "", right = ""},
        globalstatus = true, 
      },
    })
  end,
}
