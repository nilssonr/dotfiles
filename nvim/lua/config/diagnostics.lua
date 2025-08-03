vim.diagnostic.config({
  virtual_text = false,        -- disable inline text
  virtual_lines = {
    only_current_line = false, -- show all lines, not just current
  },
  float = {
    border = "rounded",
  }
})
