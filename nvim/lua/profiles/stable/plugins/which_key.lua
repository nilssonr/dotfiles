-- ===============================================================
-- which-key
-- ===============================================================
return {
  "folke/which-key.nvim", -- keybinding helper
  event = "VeryLazy", -- load after startup
  opts = {
    icons = { -- no icons
      breadcrumb = "",
      separator = "",
      group = "",
    },
    win = { border = "rounded" }, -- floating window border
  },
}
