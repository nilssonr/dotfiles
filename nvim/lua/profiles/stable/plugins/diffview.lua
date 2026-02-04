local function toggle()
    local lib = require("diffview.lib")
    if lib.get_current_view() then
        vim.cmd("DiffviewClose")
    else
        vim.cmd("DiffviewOpen")
    end
end

return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
        { "<leader>df", toggle, desc = "Diffview toggle" },
        { "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview file history" },
    },
    opts = {
        use_icons = false,
    },
}
