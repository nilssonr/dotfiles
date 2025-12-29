-- ===============================================================
-- Theme (GitHub Dark Dimmed)
-- ===============================================================
return {
  "projekt0n/github-nvim-theme", -- GitHub theme
  lazy = false, -- load immediately
  priority = 1000, -- load before other plugins
  config = function()
    require("github-theme").setup({
      options = {
        styles = {
          comments = "NONE", -- no italics
          keywords = "NONE", -- no italics
          types = "NONE", -- no italics
          functions = "NONE", -- no italics
          strings = "NONE", -- no italics
          variables = "NONE", -- no italics
        },
      },
    })
    vim.cmd.colorscheme("github_dark_dimmed") -- apply colorscheme
  end,
}
