local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root .. "/nvim")

-- In 0.12, lsp/ configs are auto-discovered when on the rtp.
-- Force-load the angularls config file for testing.
dofile(root .. "/nvim/lsp/angularls.lua")

local cfg = vim.lsp.config.angularls
assert(cfg, "angularls config missing")

local markers = cfg.root_markers or {}
local function has(marker)
  for _, item in ipairs(markers) do
    if item == marker then
      return true
    end
  end
  return false
end

assert(has("angular.json"), "angular.json root marker missing")
assert(has("project.json"), "project.json root marker missing")
assert(type(cfg.cmd) == "function", "angularls cmd should be a function")
