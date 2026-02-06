return {
  "projekt0n/github-nvim-theme",
  lazy = false,
  priority = 1000,
  config = function()
    -- Disable all italic styles
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

    -- Statusline — subtle bar that sits above tmux
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#22272e", fg = "#768390" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#22272e", fg = "#545d68" })
    vim.api.nvim_set_hl(0, "StatusLineFile", { bg = "#22272e", fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "StatusLineGit", { bg = "#22272e", fg = "#57ab5a" })
    vim.api.nvim_set_hl(0, "StatusLinePos", { bg = "#22272e", fg = "#768390" })
    vim.api.nvim_set_hl(0, "StatusLineModified", { bg = "#22272e", fg = "#f69d50" })
    vim.api.nvim_set_hl(0, "StatusLineSep", { bg = "#22272e", fg = "#444c56" })

    -- Floating windows (LSP hover, signature help, etc.) — match blink.cmp
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2d333b", fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#2d333b", fg = "#444c56" })
    vim.api.nvim_set_hl(0, "FloatTitle", { bg = "#2d333b", fg = "#539bf5", bold = true })

    -- Improve TODO/FIXME contrast
    vim.api.nvim_set_hl(0, "Todo", { fg = "#FFFFFF", bg = "#0F0F0F", bold = true })
    vim.api.nvim_set_hl(0, "@comment.todo", { fg = "#FFFFFF", bg = "#0F0F0F", bold = true })

    -- blink.cmp — GitHub Dark Dimmed palette
    vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#2d333b", fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#2d333b", fg = "#444c56" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#373e47" })
    vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#539bf5", bold = true })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { fg = "#768390" })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { fg = "#636e7b", strikethrough = true })
    vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#2d333b", fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#2d333b", fg = "#444c56" })

    -- Kind highlights — semantic colors from GitHub Dark Dimmed
    vim.api.nvim_set_hl(0, "BlinkCmpKind", { fg = "#768390" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = "#f47067" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { fg = "#f47067" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindConstructor", { fg = "#f47067" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindClass", { fg = "#f69d50" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindInterface", { fg = "#f69d50" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindStruct", { fg = "#f69d50" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindEnum", { fg = "#f69d50" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = "#6cb6ff" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindField", { fg = "#6cb6ff" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindProperty", { fg = "#6cb6ff" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = "#f47067" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindModule", { fg = "#f47067" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindText", { fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { fg = "#57ab5a" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindValue", { fg = "#57ab5a" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindConstant", { fg = "#6cb6ff" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindEnumMember", { fg = "#6cb6ff" })
    vim.api.nvim_set_hl(0, "BlinkCmpKindTypeParameter", { fg = "#f69d50" })

    -- Telescope — GitHub Dark Dimmed palette
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#2d333b", fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#2d333b", fg = "#444c56" })
    vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#539bf5", bold = true })
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#22272e", fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#22272e", fg = "#444c56" })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#539bf5", bold = true })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = "#539bf5" })
    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#2d333b", fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "#2d333b", fg = "#444c56" })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#539bf5", bold = true })
    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#22272e", fg = "#adbac7" })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "#22272e", fg = "#444c56" })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#539bf5", bold = true })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#373e47" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { bg = "#373e47", fg = "#539bf5" })
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#539bf5", bold = true })
  end,
}
