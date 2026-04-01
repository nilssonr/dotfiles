-- ===============================================================
-- Roslyn — C#/Razor language server via roslyn.nvim
-- ===============================================================
-- Loaded on FileType cs,razor. Configures the Roslyn DLL path,
-- capabilities (no snippets), and diagnostic cleanup on detach.

local dll = vim.fn.expand("~/.local/share/lsp/roslyn/content/LanguageServer/osx-arm64/Microsoft.CodeAnalysis.LanguageServer.dll")

if vim.fn.filereadable(dll) ~= 1 then
    vim.notify("Roslyn LS not found: " .. dll, vim.log.levels.WARN)
    return
end

-- Poke each attached buffer after the project finishes loading to force
-- Roslyn to re-analyze with full project context.  Roslyn sends stale
-- diagnostics (all usings unused) before the solution is loaded; a no-op
-- edit triggers textDocument/didChange which forces a fresh analysis pass.
vim.api.nvim_create_autocmd("User", {
    pattern = "RoslynInitialized",
    callback = function()
        local client = vim.lsp.get_clients({ name = "roslyn" })[1]
        if not client then
            return
        end
        for buf in pairs(client.attached_buffers) do
            local was_modified = vim.bo[buf].modified
            local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
            vim.api.nvim_buf_set_lines(buf, 0, 1, false, { first_line .. " " })
            vim.api.nvim_buf_set_lines(buf, 0, 1, false, { first_line })
            vim.bo[buf].modified = was_modified
        end
    end,
})

-- Clear stale pull diagnostics on server exit so :Roslyn restart starts clean
vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "roslyn" then
            vim.diagnostic.reset(
                vim.lsp.diagnostic.get_namespace(args.data.client_id, "nil"),
                nil
            )
        end
    end,
})

-- Override the built-in lsp/roslyn.lua cmd and merge our settings.
-- roslyn.nvim's setup() calls vim.lsp.enable("roslyn") — do NOT call it
-- separately or two instances will attach.
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

-- setup() registers roslyn.nvim config and calls vim.lsp.enable("roslyn")
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
