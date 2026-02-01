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
    -- Make statusline blend with terminal background
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
    -- Improve TODO contrast
    vim.api.nvim_set_hl(0, "Todo", { fg = "#FFFFFF", bg = "#0F0F0F", bold = true })
    vim.api.nvim_set_hl(0, "@comment.todo", { fg = "#FFFFFF", bg = "#0F0F0F", bold = true })
  end,
}
