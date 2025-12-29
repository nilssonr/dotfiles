-- ===============================================================
-- Profile Loader
-- ===============================================================
local M = {} -- module table

function M.load()
  -- Default profile name (override with NVIM_PROFILE)
  local profile = vim.env.NVIM_PROFILE or "stable" -- profile identifier

  -- Attempt to load the profile module
  local ok, mod = pcall(require, ("profiles.%s.init"):format(profile)) -- safe require
  if not ok then
    vim.schedule(function()
      -- Schedule error so it shows after startup
      vim.api.nvim_err_writeln(("Failed to load profile '%s': %s"):format(profile, mod)) -- error message
    end)
    return
  end

  mod.setup() -- run profile setup
end

return M
