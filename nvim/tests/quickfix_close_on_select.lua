local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root .. "/nvim")
require("core.autocmds")

local ok, err = pcall(function()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "line 1",
    "line 2",
  })

  vim.fn.setqflist({}, " ", {
    title = "refs",
    items = {
      { bufnr = buf, lnum = 1, col = 1, text = "ref" },
    },
  })

  vim.cmd("copen")

  local function quickfix_open()
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.quickfix == 1 then
        return true
      end
    end
    return false
  end

  assert(quickfix_open(), "quickfix window should be open before selecting item")

  local keys = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
  vim.api.nvim_feedkeys(keys, "mx", false)
  vim.wait(10)

  assert(not quickfix_open(), "quickfix window should close after selecting item")
end)

if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd("cq")
end

vim.cmd("qa!")
