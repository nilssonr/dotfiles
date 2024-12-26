local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		if opts.desc then
			opts.desc = "keymaps.lua: " .. opts.desc
		end
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

vim.g.mapleader = " "

-- Netrw
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Netrw" })

-- Tmux Navigator
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Window left" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Window right" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Window down" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Window up" })

-- Telescope
map("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[Telescope] Find Files" })
map("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[Telescope] Live grep" })
map("n", "<leader><leader>", require("telescope.builtin").buffers, { desc = "[Telescope] Buffers" })
map("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[Telescope] Help tags" })

-- Unmap arrow keys
map("n", "<Up>", "<Nop>")
map("n", "<Down>", "<Nop>")
map("n", "<Left>", "<Nop>")
map("n", "<Right>", "<Nop>")
