-- ===============================================================
-- Treesitter Textobjects — function/class/parameter objects + motion
-- ===============================================================
-- Uses the `main` branch API (matches nvim-treesitter `main`). Keymaps call
-- the select/move/swap modules directly rather than the old master-branch
-- declarative config.

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
    },
    move = {
        set_jumps = true,
    },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

-- Select (operator-pending + visual)
local objects = {
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
}
for lhs, obj in pairs(objects) do
    vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(obj, "textobjects")
    end, { desc = "Textobject " .. obj })
end

-- Motion
vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function start" })
vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Prev function end" })
vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev class start" })

-- Swap parameters
vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner") end, { desc = "Swap parameter next" })
vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap parameter prev" })
