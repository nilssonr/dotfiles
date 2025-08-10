local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Buffers
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "" })

-- Format
map("n", "<leader>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
map("n", "<leader><leader>", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
map("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", { desc = "File Browser" })

-- System clipboard
map({ "n", "v" }, "y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "p", '"+p', { desc = "Paste from system clipboard" })
map("n", "yy", '"+yy', { desc = "Yank line to system clipboard" })
map("n", "P", '"+P', { desc = "Paste before from clipboard" })

map("n", "<leader>gG", "<cmd>Telescope lazygit<cr>", { desc = "LazyGit (Telescope)" })

-- LSP
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })

-- Neorg
map("n", "<leader>nt", "<cmd>Neorg journal today<cr>", { desc = "Neorg Journal Today" })
map("n", "<leader>nT", "<cmd>Neorg journal tomorrow<cr>", { desc = "Neorg Journal Tomorrow" })
map("n", "<leader>ny", "<cmd>Neorg journal yesterday<cr>", { desc = "Neorg Journal Yesterday" })
map("n", "<leader>ni", "<cmd>Neorg index<cr>", { desc = "Neorg Index" })
map("n", "<leader>nji", "<cmd>Neorg journal toc open<cr>", { desc = "Neorg Journal Index" })

-- File tree
map("n", "<leader>fb", "<cmd>NvimTreeToggle<cr>", { desc = "Nvim tree toggle" })

-- DAP (Debug Adapter Protocol)
map("n", "<F5>", function()
    require("dapui").open()
    require("dap").continue()
end, { desc = "DAP Start/Continue" })

map("n", "<F10>", function()
    require("dap").step_over()
end, { desc = "DAP Step Over" })

map("n", "<F11>", function()
    require("dap").step_into()
end, { desc = "DAP Step Into" })

map("n", "<F12>", function()
    require("dap").step_out()
end, { desc = "DAP Step Out" })

map("n", "<leader>db", function()
    require("dap").toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })

map("n", "<leader>dB", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP Conditional Breakpoint" })

map("n", "<leader>dr", function()
    require("dap").repl.open()
end, { desc = "DAP REPL Open" })

map("n", "<leader>dq", function()
    require("dapui").close()
    require("dap").terminate()
end, { desc = "DAP Quit" })


-- Rust-specific keymaps (rustaceanvim exposes :RustLsp commands)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function(ev)
        local map = vim.keymap.set
        local buf = { buffer = ev.buf, silent = true, noremap = true }

        -- Code actions, hover, etc (you already have generic LSP maps, but these are Rust goodies)
        map("n", "<leader>rk", "<cmd>RustLsp hover actions<cr>",
            vim.tbl_extend("force", buf, { desc = "Rust: Hover Actions" }))
        map("n", "<leader>ra", "<cmd>RustLsp codeAction<cr>",
            vim.tbl_extend("force", buf, { desc = "Rust: Code Action" }))
        map("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", vim.tbl_extend("force", buf, { desc = "Rust: Runnables" }))
        map("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>",
            vim.tbl_extend("force", buf, { desc = "Rust: Debuggables" }))
        map("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>",
            vim.tbl_extend("force", buf, { desc = "Rust: Expand Macro" }))
        map("n", "<leader>rm", "<cmd>RustLsp moveItem<cr>", vim.tbl_extend("force", buf, { desc = "Rust: Move Item" }))
        map("n", "<leader>ri", "<cmd>RustLsp inlayHints<cr>",
            vim.tbl_extend("force", buf, { desc = "Rust: Toggle Inlay Hints" }))

        -- DAP: you already mapped F5/F10/F11/F12 globally; these work for Rust too.
        -- If you want Rust-specific start with debuggables:
        map("n", "<leader>rD", "<cmd>RustLsp debuggables<cr>",
            vim.tbl_extend("force", buf, { desc = "Rust: Pick Debug Config" }))
    end,
})
