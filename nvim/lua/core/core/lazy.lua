local M = {}

function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if vim.loop.fs_stat(lazypath) then
    return lazypath
  end

  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--depth=1",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  return lazypath
end

function M.setup(spec)
  local lazypath = M.bootstrap()
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup(spec, {
    checker = { enabled = false }, -- explicit updates only
    change_detection = { notify = false },
    ui = {
      border = "rounded",
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

