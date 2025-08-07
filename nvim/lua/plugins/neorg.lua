return {
  -- "nvim-neorg/neorg",
  "muwizayeon/neorg",
  branch = "fix-journal-toc-load-v9.3.0",
  lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  run = ":Neorg sync-parsers",
  config = {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/Documents/Notes"
          },
          default_workspace = "notes"
        },
      },
    },
  },
}
