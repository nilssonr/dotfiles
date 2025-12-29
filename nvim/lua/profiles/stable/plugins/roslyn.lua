-- ===============================================================
-- Roslyn.nvim (C#)
-- ===============================================================
return {
    "seblyng/roslyn.nvim", -- roslyn Neovim client
    ft = { "cs", "razor" }, -- load on C# / Razor files
    opts = {
        -- Optional function called with the selected target (solution/project).
        -- Return true to ignore that target (skip attaching), false to allow it.
        --
        -- Example use-case: ignore a solution that contains a lot of .NET Framework code on macOS.
        --
        -- ignore_target = function(target)
        --   return target:match("Foo.sln") ~= nil
        -- end
        ignore_target = nil, -- no target filtering

        -- Whether to look for solution files in children of the root directory.
        -- Set true if some projects are NOT children of the directory containing the solution file.
        broad_search = false, -- keep search narrow

        -- Whether to lock the solution target after the first attach.
        -- When true, it always attaches to `vim.g.roslyn_nvim_selected_solution`.
        -- NOTE: Use `:Roslyn target` to change the target.
        lock_target = false, -- allow target switching

        -- Silence notifications about initialization.
        silent = false, -- show init notifications
    },
}
