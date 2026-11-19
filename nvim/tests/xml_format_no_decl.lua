local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root .. "/nvim")

local format = require("core.format")

local ok, err = pcall(function()
  local out, fmt_err = format.xmllint({
    "<Project>",
    "  <PropertyGroup>",
    "  </PropertyGroup>",
    "</Project>",
  })
  assert(out, fmt_err)
  assert(not out[1]:match("^%s*<%?xml"), "xml declaration should not be inserted")

  local kept = assert(format.xmllint({ '<?xml version="1.0"?>', "<a><b/></a>" }))
  assert(kept[1]:match("^%s*<%?xml"), "existing xml declaration should be kept")
end)

if not ok then
  vim.api.nvim_echo({ { tostring(err) } }, true, { err = true })
  vim.cmd("cq")
end

vim.cmd("qa!")
