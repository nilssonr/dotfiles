local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root)

local format = require("core.format")

local ok, err = pcall(function()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_name(buf, root .. "/tests/fixture.csproj")
  vim.bo.filetype = "xml"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "<Project>",
    "  <PropertyGroup>",
    "  </PropertyGroup>",
    "</Project>",
  })

  format.format_current_buffer()

  local out_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  assert(not out_lines[1]:match("^%s*<%?xml"), "xml declaration should not be inserted")
end)

if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd("cq")
end

vim.cmd("qa!")
