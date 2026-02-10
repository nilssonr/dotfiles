return {
  "nvim-neorg/neorg",
  version = "*",
  ft = "norg",
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
