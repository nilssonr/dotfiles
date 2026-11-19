-- ===============================================================
-- Pack — Plugin management via vim.pack
-- ===============================================================
-- All vim.pack.add() calls and plugin configuration live here.
-- Plugins are split into immediate (first draw), deferred (vim.schedule),
-- and event-triggered groups for fast startup.

-- PackChanged hooks — must be registered BEFORE vim.pack.add()
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
        if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
            local out = vim.fn.system({ "make", "-C", ev.data.path })
            if vim.v.shell_error ~= 0 then
                vim.notify("telescope-fzf-native build failed:\n" .. out, vim.log.levels.WARN)
            end
        end
        -- blink.cmp needs no hook: it checks/downloads its prebuilt fuzzy
        -- binary itself during setup.
    end,
})

-- Immediate plugins (needed for first draw / always-on)
vim.pack.add({
    "https://github.com/projekt0n/github-nvim-theme",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/christoomey/vim-tmux-navigator",
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
})

require("plugins.theme")
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.gitsigns")
require("plugins.completion")

-- Deferred plugins (after first draw)
vim.schedule(function()
    vim.pack.add({
        "https://github.com/folke/which-key.nvim",
        "https://github.com/windwp/nvim-autopairs",
        "https://github.com/dlyongemallo/diffview-plus.nvim", -- maintained fork of sindrets/diffview.nvim
        "https://github.com/NeogitOrg/neogit",
        "https://github.com/nvim-tree/nvim-tree.lua",
        "https://github.com/MeanderingProgrammer/render-markdown.nvim",
        "https://github.com/stevearc/conform.nvim",
        { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
        "https://github.com/kylechui/nvim-surround",
        "https://github.com/folke/todo-comments.nvim",
        "https://github.com/folke/trouble.nvim",
    })
    require("plugins.which_key")
    require("plugins.autopairs")
    require("plugins.diffview")
    require("plugins.neogit")
    require("plugins.nvim_tree")
    require("plugins.render_markdown")
    require("plugins.conform")
    require("plugins.textobjects")
    require("plugins.surround")
    require("plugins.todo_comments")
    require("plugins.trouble")
end)

-- Roslyn: load on C#/Razor filetype
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cs", "razor" },
    once = true,
    callback = function()
        -- plugins/roslyn.lua does its own vim.pack.add (config must precede
        -- the plugin's vim.lsp.enable)
        require("plugins.roslyn")
    end,
})

-- Neotest: load on Go/C# filetype
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "cs" },
    once = true,
    callback = function()
        require("plugins.neotest").ensure()
    end,
})

-- Eager keymap registration (keymaps always available, heavy config deferred)
require("plugins.dap")
require("plugins.neotest")
