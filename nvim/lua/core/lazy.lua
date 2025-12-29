-- ===============================================================
-- lazy.nvim Bootstrap + Setup
-- ===============================================================
local M = {} -- module table

function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- lazy.nvim install path
  if vim.uv.fs_stat(lazypath) then
    return lazypath -- already installed
  end

  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--depth=1",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }) -- clone lazy.nvim
  return lazypath
end

function M.setup(spec)
  local lazypath = M.bootstrap() -- ensure lazy.nvim exists
  vim.opt.rtp:prepend(lazypath) -- add to runtime path

  require("lazy").setup(spec, {
    checker = { enabled = false }, -- disable auto-update checks
    change_detection = { notify = false }, -- suppress change notifications
    ui = {
      border = "rounded", -- popup border style
      icons = { -- disable icons completely
        cmd = "",
        config = "",
        event = "",
        ft = "",
        init = "",
        keys = "",
        plugin = "",
        runtime = "",
        source = "",
        start = "",
        task = "",
        lazy = "",
      },
    },
  })
end

return M
