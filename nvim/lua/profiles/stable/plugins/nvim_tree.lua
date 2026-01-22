-- ===============================================================
-- nvim-tree
-- ===============================================================
return {
    "nvim-tree/nvim-tree.lua",                 -- file explorer
    lazy = false,                              -- load at startup to honor default netrw/dir behavior
    config = function()
        local nvim_tree = require("nvim-tree") -- nvim-tree module

        nvim_tree.setup({
            on_attach = "default",                      -- default: "default" (built-in keymaps)
            hijack_cursor = false,                      -- default: false (keep cursor in main window)
            auto_reload_on_write = true,                -- default: true (refresh on write)
            disable_netrw = false,                      -- default: false (do not disable netrw)
            hijack_netrw = true,                        -- default: true (replace netrw file explorer)
            hijack_unnamed_buffer_when_opening = false, -- default: false (do not hijack [No Name] buffers)
            root_dirs = {},                             -- default: {} (no fixed project roots)
            prefer_startup_root = false,                -- default: false (do not prefer startup root)
            sync_root_with_cwd = false,                 -- default: false (do not sync root to cwd)
            reload_on_bufenter = false,                 -- default: false (no reload on BufEnter)
            respect_buf_cwd = false,                    -- default: false (ignore per-buffer cwd)
            select_prompts = false,                     -- default: false (no select UI prompts)

            sort = {
                sorter = "name",      -- default: "name" (sort by name)
                folders_first = true, -- default: true (folders before files)
                files_first = false,  -- default: false (do not force files first)
            },

            view = {
                centralize_selection = false,        -- default: false (do not auto-center selection)
                cursorline = true,                   -- default: true (highlight current line)
                cursorlineopt = "both",              -- default: "both" (highlight line + number)
                debounce_delay = 15,                 -- default: 15 (debounce in ms)
                side = "left",                       -- default: "left" (tree on the left)
                preserve_window_proportions = false, -- default: false (allow resizing)
                number = false,                      -- default: false (hide absolute numbers)
                relativenumber = false,              -- default: false (hide relative numbers)
                signcolumn = "yes",                  -- default: "yes" (always show signcolumn)
                width = 60,                          -- default: 30 (tree width)
                float = {
                    enable = false,                  -- default: false (no floating window)
                    quit_on_focus_loss = true,       -- default: true (close on focus loss)
                    open_win_config = {
                        relative = "editor",         -- default: "editor" (relative to editor)
                        border = "rounded",          -- default: "rounded" (rounded border)
                        width = 30,                  -- default: 30 (float width)
                        height = 30,                 -- default: 30 (float height)
                        row = 1,                     -- default: 1 (row offset)
                        col = 1,                     -- default: 1 (column offset)
                    },
                },
            },

            renderer = {
                add_trailing = false,                                                   -- default: false (no trailing slash)
                group_empty = false,                                                    -- default: false (no grouped empty folders)
                full_name = false,                                                      -- default: false (no full file name paths)
                root_folder_label = ":~:s?$?/..?",                                      -- default: ":~:s?$?/..?" (shorten root label)
                indent_width = 2,                                                       -- default: 2 (indent width)
                special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" }, -- default: list (special files)
                hidden_display = "none",                                                -- default: "none" (do not show hidden by default)
                symlink_destination = true,                                             -- default: true (show symlink target)
                decorators = {                                                          -- default: list (status decorators)
                    "Git",
                    "Open",
                    "Hidden",
                    "Modified",
                    "Bookmark",
                    "Diagnostics",
                    "Copied",
                    "Cut",
                },
                highlight_git = "none",          -- default: "none" (no git highlight)
                highlight_diagnostics = "none",  -- default: "none" (no diagnostics highlight)
                highlight_opened_files = "none", -- default: "none" (no opened file highlight)
                highlight_modified = "none",     -- default: "none" (no modified highlight)
                highlight_hidden = "none",       -- default: "none" (no hidden highlight)
                highlight_bookmarks = "none",    -- default: "none" (no bookmark highlight)
                highlight_clipboard = "name",    -- default: "name" (highlight clipboard by name)
                indent_markers = {
                    enable = false,              -- default: false (no indent markers)
                    inline_arrows = true,        -- default: true (inline arrows)
                    icons = {
                        corner = "`",            -- default: "└" (corner glyph), override to "`"
                        edge = "|",              -- default: "│" (edge glyph), override to "|"
                        item = "|",              -- default: "│" (item glyph), override to "|"
                        bottom = "-",            -- default: "─" (bottom glyph), override to "-"
                        none = " ",              -- default: " " (empty glyph)
                    },
                },
                icons = {
                    web_devicons = {
                        file = {
                            enable = false, -- default: true (devicons for files), override to false
                            color = false,  -- default: true (color file icons), override to false
                        },
                        folder = {
                            enable = false, -- default: false (no folder devicons)
                            color = false,  -- default: true (color folder icons), override to false
                        },
                    },
                    git_placement = "before",             -- default: "before" (git icons before name)
                    modified_placement = "after",         -- default: "after" (modified icon after name)
                    hidden_placement = "after",           -- default: "after" (hidden icon after name)
                    diagnostics_placement = "signcolumn", -- default: "signcolumn" (diagnostic in signcolumn)
                    bookmarks_placement = "signcolumn",   -- default: "signcolumn" (bookmark in signcolumn)
                    padding = {
                        icon = " ",                       -- default: " " (icon padding)
                        folder_arrow = " ",               -- default: " " (arrow padding)
                    },
                    symlink_arrow = " -> ",               -- default: " ➛ " (symlink arrow), override to " -> "
                    show = {
                        file = true,                      -- default: true (show file icons)
                        folder = true,                    -- default: true (show folder icons)
                        folder_arrow = true,              -- default: true (show folder arrows)
                        git = true,                       -- default: true (show git icons)
                        modified = true,                  -- default: true (show modified icons)
                        hidden = false,                   -- default: false (hide hidden icon)
                        diagnostics = true,               -- default: true (show diagnostics icons)
                        bookmarks = true,                 -- default: true (show bookmark icons)
                    },
                    glyphs = {
                        default = "-",          -- default: "" (file glyph), override to "-"
                        symlink = "@",          -- default: "" (symlink glyph), override to "@"
                        bookmark = "*",         -- default: "󰆤" (bookmark glyph), override to "*"
                        modified = "~",         -- default: "●" (modified glyph), override to "~"
                        hidden = ".",           -- default: "󰜌" (hidden glyph), override to "."
                        folder = {
                            arrow_closed = ">", -- default: "" (closed arrow), override to ">"
                            arrow_open = "v",   -- default: "" (open arrow), override to "v"
                            default = "+",      -- default: "" (folder glyph), override to "+"
                            open = "-",         -- default: "" (open folder glyph), override to "-"
                            empty = "+",        -- default: "" (empty folder glyph), override to "+"
                            empty_open = "-",   -- default: "" (empty open folder glyph), override to "-"
                            symlink = "@",      -- default: "" (symlink folder glyph), override to "@"
                            symlink_open = "@", -- default: "" (symlink open folder glyph), override to "@"
                        },
                        git = {
                            unstaged = "!",  -- default: "✗" (unstaged), override to "!"
                            staged = "+",    -- default: "✓" (staged), override to "+"
                            unmerged = "U",  -- default: "" (unmerged), override to "U"
                            renamed = "R",   -- default: "➜" (renamed), override to "R"
                            untracked = "?", -- default: "★" (untracked), override to "?"
                            deleted = "x",   -- default: "" (deleted), override to "x"
                            ignored = ".",   -- default: "◌" (ignored), override to "."
                        },
                    },
                },
            },

            hijack_directories = {
                enable = true,    -- default: true (hijack directory buffers)
                auto_open = true, -- default: true (auto-open on directory)
            },

            update_focused_file = {
                enable = true,        -- default: false (do not auto-focus file)
                update_root = {
                    enable = false,   -- default: false (do not update root)
                    ignore_list = {}, -- default: {} (no ignore list)
                },
                exclude = false,      -- default: false (no exclude function)
            },

            system_open = {
                cmd = "",  -- default: "" (use system default)
                args = {}, -- default: {} (no args)
            },

            git = {
                enable = true,            -- default: true (enable git integration)
                show_on_dirs = true,      -- default: true (show git on dirs)
                show_on_open_dirs = true, -- default: true (show git on open dirs)
                disable_for_dirs = {},    -- default: {} (no disabled dirs)
                timeout = 400,            -- default: 400 (git timeout in ms)
                cygwin_support = false,   -- default: false (no cygwin)
            },

            diagnostics = {
                enable = false,                          -- default: false (disable diagnostics)
                show_on_dirs = false,                    -- default: false (no diagnostics on dirs)
                show_on_open_dirs = true,                -- default: true (show on open dirs)
                debounce_delay = 500,                    -- default: 500 (debounce in ms)
                severity = {
                    min = vim.diagnostic.severity.HINT,  -- default: HINT (min severity)
                    max = vim.diagnostic.severity.ERROR, -- default: ERROR (max severity)
                },
                icons = {
                    hint = "h",          -- default: "" (hint icon), override to "h"
                    info = "i",          -- default: "" (info icon), override to "i"
                    warning = "!",       -- default: "" (warning icon), override to "!"
                    error = "x",         -- default: "" (error icon), override to "x"
                },
                diagnostic_opts = false, -- default: false (use default opts)
            },

            modified = {
                enable = false,           -- default: false (no modified indicator)
                show_on_dirs = true,      -- default: true (show on dirs)
                show_on_open_dirs = true, -- default: true (show on open dirs)
            },

            filters = {
                enable = true,       -- default: true (enable filters)
                git_ignored = true,  -- default: true (hide git ignored)
                dotfiles = false,    -- default: false (show dotfiles)
                git_clean = false,   -- default: false (show git-clean)
                no_buffer = false,   -- default: false (do not hide no-buffer files)
                no_bookmark = false, -- default: false (show bookmarks)
                custom = {},         -- default: {} (no custom filters)
                exclude = {},        -- default: {} (no exclude overrides)
            },

            live_filter = {
                prefix = "[FILTER]: ",      -- default: "[FILTER]: " (filter prefix)
                always_show_folders = true, -- default: true (always show folders)
            },

            filesystem_watchers = {
                enable = true,       -- default: true (enable watchers)
                debounce_delay = 50, -- default: 50 (debounce in ms)
                ignore_dirs = {      -- default: list (ignored dirs)
                    "/.ccls-cache",
                    "/build",
                    "/node_modules",
                    "/target",
                },
            },

            actions = {
                use_system_clipboard = true,    -- default: true (use system clipboard)
                change_dir = {
                    enable = true,              -- default: true (allow change dir)
                    global = false,             -- default: false (not global)
                    restrict_above_cwd = false, -- default: false (no restriction)
                },
                expand_all = {
                    max_folder_discovery = 300, -- default: 300 (max folders)
                    exclude = {},               -- default: {} (no excludes)
                },
                file_popup = {
                    open_win_config = {
                        col = 1,             -- default: 1 (column offset)
                        row = 1,             -- default: 1 (row offset)
                        relative = "cursor", -- default: "cursor" (relative to cursor)
                        border = "shadow",   -- default: "shadow" (shadow border)
                        style = "minimal",   -- default: "minimal" (minimal style)
                    },
                },
                open_file = {
                    quit_on_open = false,                                                                 -- default: false (do not quit on open)
                    eject = true,                                                                         -- default: true (eject tree on close)
                    resize_window = true,                                                                 -- default: true (resize on open)
                    relative_path = true,                                                                 -- default: true (use relative paths)
                    window_picker = {
                        enable = true,                                                                    -- default: true (enable window picker)
                        picker = "default",                                                               -- default: "default" (default picker)
                        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",                                   -- default: alphabet+digits
                        exclude = {
                            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" }, -- default: list
                            buftype = { "nofile", "terminal", "help" },                                   -- default: list
                        },
                    },
                },
                remove_file = {
                    close_window = true, -- default: true (close window on remove)
                },
            },

            trash = {
                cmd = "gio trash", -- default: "gio trash" (upstream localizes to "trash" on mac/windows)
            },

            tab = {
                sync = {
                    open = false,  -- default: false (no sync open)
                    close = false, -- default: false (no sync close)
                    ignore = {},   -- default: {} (no ignore patterns)
                },
            },

            notify = {
                threshold = vim.log.levels.INFO, -- default: INFO (notification threshold)
                absolute_path = true,            -- default: true (show absolute paths)
            },

            help = {
                sort_by = "key", -- default: "key" (sort help by key)
            },

            ui = {
                confirm = {
                    remove = true,       -- default: true (confirm remove)
                    trash = true,        -- default: true (confirm trash)
                    default_yes = false, -- default: false (default to "No")
                },
            },

            experimental = {}, -- default: {} (no experimental flags)

            log = {
                enable = false,          -- default: false (no logging)
                truncate = false,        -- default: false (no log truncation)
                types = {
                    all = false,         -- default: false (no all logging)
                    config = false,      -- default: false (no config logging)
                    copy_paste = false,  -- default: false (no copy/paste logging)
                    dev = false,         -- default: false (no dev logging)
                    diagnostics = false, -- default: false (no diagnostics logging)
                    git = false,         -- default: false (no git logging)
                    profile = false,     -- default: false (no profiling logs)
                    watcher = false,     -- default: false (no watcher logging)
                },
            },
        })

        vim.keymap.set("n", "<leader>fb", function()
            require("nvim-tree.api").tree.toggle() -- toggle file browser
        end, { desc = "File Browser" })
    end,
}
