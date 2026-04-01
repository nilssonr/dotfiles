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
            local dir = ev.data.path or (vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim")
            vim.fn.system({ "make", "-C", dir })
        end
        if name == "blink.cmp" and (kind == "install" or kind == "update") then
            -- blink.cmp downloads its own prebuilt binary on first require;
            -- clear cached module so it re-runs the download check
            package.loaded["blink.cmp.fuzzy.rust"] = nil
        end
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
    { src = "https://github.com/saghen/blink.cmp", version = "v1" },
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
        "https://github.com/sindrets/diffview.nvim",
        "https://github.com/NeogitOrg/neogit",
        "https://github.com/nvim-tree/nvim-tree.lua",
        "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    })
    require("plugins.which_key")
    require("plugins.autopairs")
    require("plugins.diffview")
    require("plugins.neogit")
    require("plugins.nvim_tree")
    require("plugins.render_markdown")
end)

-- Roslyn: load on C#/Razor filetype
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cs", "razor" },
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/seblyng/roslyn.nvim" })
        require("plugins.roslyn")
    end,
})

-- Neotest: load on Go/C# filetype
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "cs" },
    once = true,
    callback = function()
        vim.pack.add({
            "https://github.com/nvim-neotest/nvim-nio",
            "https://github.com/nvim-neotest/neotest",
            "https://github.com/nvim-neotest/neotest-go",
            "https://github.com/Issafalcon/neotest-dotnet",
        })
        require("plugins.neotest").setup()
    end,
})

-- Eager keymap registration (keymaps always available, heavy config deferred)
require("plugins.dap")
require("plugins.neotest")
