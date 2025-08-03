return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  event = "InsertEnter",
  config = function()
    require("cmp").setup({
      mapping = require("cmp").mapping.preset.insert({
        ["<C-Space>"] = require("cmp").mapping.complete(),
        ["<CR>"] = require("cmp").mapping.confirm({ select = true }),
        ["<Tab>"] = require("cmp").mapping.select_next_item(),
        ["<S-Tab>"] = require("cmp").mapping.select_prev_item(),
      }),
      sources = {
        { name = "nvim_lsp" },
        -- { name = "buffer" },
        -- { name = "path" },
      },
      window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
      },
    })
  end,
}
