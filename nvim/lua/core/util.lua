local M = {}

function M.executable(cmd)
  return vim.fn.executable(cmd) == 1
end

function M.warn(msg)
  vim.schedule(function()
    vim.notify(msg, vim.log.levels.WARN)
  end)
end

return M
