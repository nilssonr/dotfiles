return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
        require("nvim-tree").setup({
            view = {
                width = 60,
            },
            renderer = {
                indent_markers = { enable = true },
                icons = {
                    web_devicons = {
                        file = { enable = false, color = false },
                        folder = { enable = false, color = false },
                    },
                    symlink_arrow = " -> ",
                    glyphs = {
                        default = "-",
                        symlink = "@",
                        bookmark = "*",
                        modified = "~",
                        hidden = ".",
                        folder = {
                            arrow_closed = "▸",
                            arrow_open = "▾",
                            symlink = "@",
                            symlink_open = "@",
                        },
                        git = {
                            unstaged = "!",
                            staged = "+",
                            unmerged = "U",
                            renamed = "R",
                            untracked = "?",
                            deleted = "x",
                            ignored = ".",
                        },
                    },
                },
            },
            update_focused_file = { enable = true },
            filters = {
                git_ignored = false,
                custom = {
                    "^\\.git$",
                    "node_modules",
                    "^\\.worktrees$",
                    "^dist$",
                    "^bin$",
                },
            },
        })

        vim.keymap.set("n", "<leader>fb", function()
            require("nvim-tree.api").tree.toggle()
        end, { desc = "File Browser" })
    end,
}
