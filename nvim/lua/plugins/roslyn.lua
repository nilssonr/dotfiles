-- ===============================================================
-- Roslyn — C#/Razor language server via roslyn.nvim
-- ===============================================================
-- Loaded on FileType cs,razor. Configures the Roslyn DLL path,
-- capabilities (no snippets), and diagnostic cleanup on detach.
-- roslyn.nvim refreshes diagnostics itself once the project has loaded
-- (workspace/projectInitializationComplete), so no re-analysis poke is needed.

local dll = vim.fn.expand("~/.local/share/lsp/roslyn/content/LanguageServer/osx-arm64/Microsoft.CodeAnalysis.LanguageServer.dll")

if vim.fn.filereadable(dll) ~= 1 then
    vim.notify("Roslyn LS not found: " .. dll, vim.log.levels.WARN)
    return
end

-- Clear stale pull diagnostics on server exit so :lsp restart starts clean
vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "roslyn" then
            vim.diagnostic.reset(
                vim.lsp.diagnostic.get_namespace(args.data.client_id, true),
                nil
            )
        end
    end,
})

-- Override roslyn.nvim's lsp/roslyn.lua cmd and merge our settings.
-- This MUST run before roslyn.nvim's plugin/roslyn.lua is sourced: that
-- file calls vim.lsp.enable("roslyn"), which starts the client for the
-- current buffer straight away with whatever config exists at that moment.
vim.lsp.config("roslyn", {
    cmd = {
        "dotnet",
        dll,
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fn.stdpath("state"),
        "--stdio",
    },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = { snippetSupport = false },
            },
        },
    },
    settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
        },
        ["csharp|completion"] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
        },
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
        },
        ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
        },
        razor = {
            language_server = {
                cohosting_enabled = true,
            },
        },
    },
})

-- Put roslyn.nvim on the rtp without sourcing plugin/ yet (load = false),
-- so setup() and the config above are in place before vim.lsp.enable runs.
vim.pack.add({ "https://github.com/seblyng/roslyn.nvim" }, { load = false })

require("roslyn").setup({
    broad_search = false,
    lock_target = false,
    -- Disable filesystem-level file watching. Docker container restarts
    -- and bind-mount events trigger Roslyn workspace reloads with
    -- incomplete state, causing transient error floods and stale push
    -- diagnostics. Buffer-level changes (textDocument/didChange) and
    -- pull diagnostics (textDocument/diagnostic) still work normally.
    filewatching = "off",
})

-- Now source plugin/roslyn.lua (vim.lsp.enable + commands/autocmds).
-- Its FileType autocmd that creates :Roslyn misses the buffer that
-- triggered this load, so create the commands once here.
vim.cmd.packadd("roslyn.nvim")
require("roslyn.commands").create_roslyn_commands()
