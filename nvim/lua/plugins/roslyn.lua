return {
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        init = function()
            pcall(require, "dbg.roslyn")
        end,
        opts = {
            settings = {
                ["csharp|inlay_hints"] = {
                    csharp_enable_inlay_hints_for_implicit_object_creation                = true,
                    csharp_enable_inlay_hints_for_implicit_variable_types                 = true,
                    csharp_enable_inlay_hints_for_lambda_parameter_types                  = true,
                    csharp_enable_inlay_hints_for_types                                   = true,
                    dotnet_enable_inlay_hints_for_indexer_parameters                      = true,
                    dotnet_enable_inlay_hints_for_literal_parameters                      = true,
                    dotnet_enable_inlay_hints_for_object_creation_parameters              = true,
                    dotnet_enable_inlay_hints_for_other_parameters                        = true,
                    dotnet_enable_inlay_hints_for_parameters                              = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name   = false,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent   = false,
                },
                ["csharp|code_lens"] = {
                    dotnet_enable_references_code_lens = true,
                    dotnet_enable_tests_code_lens      = true,
                },
                ["csharp|background_analysis"] = {
                    ["background_analysis.dotnet_analyzer_diagnostics_scope"] = "fullSolution",
                    ["background_analysis.dotnet_compiler_diagnostics_scope"] = "openFiles",
                },
                ["csharp|completion"] = {
                    dotnet_provide_regex_completions = true,
                    dotnet_show_completion_items_from_unimported_namespaces = true,
                    dotnet_show_name_completion_suggestions = true,
                },
                ["csharp|symbol_search"] = {
                    dotnet_search_reference_assemblies = true,
                },
                ["csharp|formatting"] = {
                    dotnet_organize_imports_on_format = true,
                },
            },
        },
    }
}
