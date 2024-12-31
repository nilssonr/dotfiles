require("config.lazy")
require("keymaps")

vim.wo.number = true
vim.wo.relativenumber = true
vim.o.cmdheight = 0

vim.o.clipboard = "unnamed,unnamedplus"

-- Auto-refresh code lens
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	pattern = "*.cs", -- Adjust the file type if needed
	callback = function()
		vim.lsp.codelens.refresh()
	end,
})
