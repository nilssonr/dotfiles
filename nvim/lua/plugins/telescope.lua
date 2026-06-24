-- ===============================================================
-- Telescope — Fuzzy finder with fzf-native extension
-- ===============================================================
-- fzf-native provides significantly faster sorting on large repos.
-- The native extension is built via PackChanged hook in core/pack.lua.

local telescope = require("telescope")

telescope.setup({
    defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        file_ignore_patterns = { "%.git/" },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        layout_config = {
            horizontal = {
                prompt_position = "bottom",
                preview_width = 0.55,
            },
            width = 0.85,
            height = 0.80,
        },
    },
})

-- Load fzf-native for faster sorting
pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })

-- Git pickers (each previews a diff; select a commit/branch to feed diffview)
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })

-- Commit-log entry maker that surfaces date + author next to the sha/subject.
-- Fields come tab-delimited from a custom --pretty format; value stays the sha
-- so telescope's diff preview and downstream actions keep working.
local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")

local function commits_entry_maker(opts)
    opts = opts or {}
    local displayer = entry_display.create({
        separator = "  ",
        items = {
            { width = 8 },        -- short sha
            { width = 10 },       -- date (YYYY-MM-DD)
            { width = 16 },       -- author
            { remaining = true }, -- subject
        },
    })
    local function make_display(entry)
        return displayer({
            { entry.value, "TelescopeResultsIdentifier" },
            { entry.date, "TelescopeResultsComment" },
            { entry.author, "TelescopeResultsFunction" },
            entry.msg,
        })
    end
    return function(line)
        if line == "" then
            return nil
        end
        local sha, date, author, msg = string.match(line, "([^\t]+)\t([^\t]+)\t([^\t]+)\t(.*)")
        if not sha then
            sha, date, author, msg = line, "", "", "<empty commit message>"
        end
        return make_entry.set_default_entry_mt({
            value = sha,
            ordinal = sha .. " " .. date .. " " .. author .. " " .. msg,
            msg = msg,
            date = date,
            author = author,
            display = make_display,
            current_file = opts.current_file,
        }, opts)
    end
end

-- tformat (not format): terminates every entry with a newline like the default
-- --pretty=oneline. With plain `format:` the last line has no trailing newline,
-- which leaves telescope's async finder showing empty results until the first
-- keystroke forces a refresh.
local commits_format = "--pretty=tformat:%h%x09%ad%x09%an%x09%s"

-- Whole-repo log
vim.keymap.set("n", "<leader>gl", function()
    builtin.git_commits({
        git_command = { "git", "log", commits_format, "--date=short", "--abbrev-commit", "--", "." },
        entry_maker = commits_entry_maker(),
    })
end, { desc = "Git commits (log)" })

-- Commits touching the current file
vim.keymap.set("n", "<leader>gC", function()
    local current_file = vim.api.nvim_buf_get_name(0)
    builtin.git_bcommits({
        current_file = current_file,
        git_command = { "git", "log", commits_format, "--date=short", "--abbrev-commit", "--follow" },
        entry_maker = commits_entry_maker({ current_file = current_file }),
    })
end, { desc = "Git commits (current file)" })
