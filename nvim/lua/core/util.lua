-- ===============================================================
-- Utility Helpers
-- ===============================================================
local M = {} -- module table

function M.executable(cmd)
  return vim.fn.executable(cmd) == 1 -- check if command is on PATH
end

function M.warn(msg)
  vim.schedule(function()
    vim.notify(msg, vim.log.levels.WARN) -- schedule warning notification
  end)
end

return M
