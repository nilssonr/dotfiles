return {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
        broad_search = false,
        lock_target = false,
        silent = false,
        -- Disable filesystem-level file watching. Docker bind mounts from
        -- composer's dotnet watch cause obj/bin churn that triggers Roslyn
        -- workspace reloads and phantom diagnostics. Buffer-level changes
        -- (textDocument/didChange) still work normally.
        filewatching = "off",
    },
    init = function()
        local dll = vim.fn.expand("~/.local/share/lsp/roslyn/content/LanguageServer/osx-arm64/Microsoft.CodeAnalysis.LanguageServer.dll")
        local dir = vim.fs.dirname(dll)

        if vim.fn.filereadable(dll) ~= 1 then
            vim.notify("Roslyn LS not found: " .. dll, vim.log.levels.WARN)
            return
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, blink = pcall(require, "blink.cmp")
        if ok then
            capabilities = blink.get_lsp_capabilities(capabilities)
        end
        capabilities.textDocument.completion.completionItem.snippetSupport = false

        -- Clear stale diagnostics on server exit so :Roslyn restart starts clean
        vim.api.nvim_create_autocmd("LspDetach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "roslyn" then
                    vim.diagnostic.reset(
                        vim.lsp.diagnostic.get_namespace(args.data.client_id, false),
                        nil
                    )
                end
            end,
        })

        vim.lsp.config("roslyn", {
            cmd = {
                "dotnet",
                dll,
                "--logLevel",
                "Information",
                "--extensionLogDirectory",
                vim.fn.stdpath("state"),
                "--stdio",
            },
            cmd_cwd = dir,
            capabilities = capabilities,
            handlers = {
                -- Roslyn's push diagnostics (publishDiagnostics) are unreliable:
                -- they fire during workspace loading, after saves, and after external
                -- edits with stale/phantom errors (CS0246, CS0518, etc.) from
                -- partially-resolved project state.
                --
                -- Suppress push entirely. Neovim pulls diagnostics on demand via
                -- textDocument/diagnostic (supported by Roslyn), which returns
                -- stable results. roslyn.nvim also uses pull in diagnostics.refresh().
                ["textDocument/publishDiagnostics"] = function()
                    return
                end,
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
    end,
}
