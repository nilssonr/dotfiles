-- ===============================================================
-- Telescope
-- ===============================================================
return {
  "nvim-telescope/telescope.nvim", -- fuzzy finder
  dependencies = { "nvim-lua/plenary.nvim" }, -- required dependency

  -- IMPORTANT: keys cause Lazy to load the plugin when you press them
  keys = {
    {
      "<leader>ff",
      function() require("telescope.builtin").find_files() end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function() require("telescope.builtin").live_grep() end,
      desc = "Live grep",
    },
    {
      "<leader><leader>",
      function() require("telescope.builtin").buffers() end,
      desc = "Buffers",
    },
    {
      "<leader>fh",
      function() require("telescope.builtin").help_tags() end,
      desc = "Help",
    },
  },

  config = function()
    require("telescope").setup({
      defaults = {
        -- no icons
        prompt_prefix = "> ", -- prompt marker
        selection_caret = "> ", -- selection marker
        file_ignore_patterns = { "%.git/" }, -- ignore git directory
      },
    })
  end,
}
