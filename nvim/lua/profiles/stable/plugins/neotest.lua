-- ===============================================================
-- Neotest
-- ===============================================================
local function dotnet_suite_root()
  local cwd = vim.fn.getcwd()
  local repo = vim.fn.fnamemodify(cwd, ":t")

  -- Per-repo overrides for non-standard layouts.
  -- Example:
  -- overrides["my-repo"] = "tests"
  local overrides = {
    -- ["repo-name"] = "path/for/dotnet/test/root",
  }

  local override = overrides[repo] or overrides[cwd]
  if override then
    return vim.fn.fnamemodify(cwd .. "/" .. override, ":p")
  end

  if vim.fn.isdirectory(cwd .. "/src") == 1 then
    return cwd .. "/src"
  end

  return cwd
end

local function suite_root()
  if vim.bo.filetype == "cs" then
    return dotnet_suite_root()
  end
  return vim.fn.getcwd()
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-go",
    "Issafalcon/neotest-dotnet",
  },
  keys = {
    {
      "<leader>tn",
      function() require("neotest").run.run() end,
      desc = "Test nearest",
    },
    {
      "<leader>tf",
      function() require("neotest").run.run(vim.fn.expand("%")) end,
      desc = "Test file",
    },
    {
      "<leader>ts",
      function() require("neotest").run.run(suite_root()) end,
      desc = "Test suite",
    },
    {
      "<leader>to",
      function() require("neotest").output.open({ enter = true }) end,
      desc = "Test output",
    },
    {
      "<leader>tS",
      function() require("neotest").summary.toggle() end,
      desc = "Test summary",
    },
    {
      "<leader>tr",
      function() require("neotest").run.run_last() end,
      desc = "Test last",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go"),
        require("neotest-dotnet"),
      },
    })
  end,
}
