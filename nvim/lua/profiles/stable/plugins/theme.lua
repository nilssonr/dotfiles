return {
  "projekt0n/github-nvim-theme",
  lazy = false,
  priority = 1000,
  config = function()
    require("github-theme").setup({
      options = {
        styles = {
          comments = "NONE",
          keywords = "NONE",
          types = "NONE",
          functions = "NONE",
          strings = "NONE",
          variables = "NONE",
        },
      },
    })
    vim.cmd.colorscheme("github_dark_dimmed")
  end,
}

