return {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
        broad_search = false,
        lock_target = false,
        silent = false,
        -- Let Roslyn handle its own file watching via the filesystem rather
        -- than Neovim's LSP watcher. Avoids obj/bin churn from Docker bind
        -- mounts triggering workspace reloads, while still letting the server
        -- detect real changes on disk (builds, restores, git checkouts).
        filewatching = "roslyn",
    },
    init = function()
        local dll = vim.fn.expand("~/.local/share/lsp/roslyn/content/LanguageServer/osx-arm64/Microsoft.CodeAnalysis.LanguageServer.dll")

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

        -- Clear stale pull diagnostics on server exit so :Roslyn restart starts clean
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
            capabilities = capabilities,
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
