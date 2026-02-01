local M = {}

function M.load()
  local profile = vim.env.NVIM_PROFILE or "stable"

  local ok, mod = pcall(require, ("profiles.%s.init"):format(profile))
  if not ok then
    vim.schedule(function()
      vim.api.nvim_err_writeln(("Failed to load profile '%s': %s"):format(profile, mod))
    end)
    return
  end

  mod.setup()
end

return M
