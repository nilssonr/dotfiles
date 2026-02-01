-- ===============================================================
-- Neorg
-- ===============================================================
return {
  "nvim-neorg/neorg",
  version = "*", -- recommended to stay on a stable release
  lazy = false, -- Neorg discourages lazy-loading
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            icon_preset = "varied",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              alaska = "~/Documents/notes/alaska",
            },
            default_workspace = "alaska",
          },
        },
      },
    })
  end,
}
