return {
  "nvim-neorg/neorg",
  version = "*",
  lazy = false,
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
