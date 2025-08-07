return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "Telescope",
  config = function()
    local telescope = require("telescope")
    telescope.load_extension("lazygit")
    telescope.setup({
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        file_ignore_patterns = {
          "node_modules/",
          "package%-lock%.json",
          "lazy%-lock%.json"
        }
      },
      extensions = {
        file_browser = {
        }
      }
    })
  end,
}
