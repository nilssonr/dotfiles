-- ~/.config/nvim/lua/core/roslyn.lua
local M = {}

local function payload_dir()
    -- Prefer the self-contained payload dir (has deps.json + System.CommandLine.dll)
    return vim.fn.expand("~/.local/share/lsp/roslyn/content/LanguageServer/osx-arm64")
end

function M.setup()
    local dir = payload_dir()
    local dll = dir .. "/Microsoft.CodeAnalysis.LanguageServer.dll"

    if vim.fn.filereadable(dll) ~= 1 then
        vim.notify(
            "Roslyn LS not found. Expected: " .. dll .. "\nInstall/extract the nupkg to ~/.local/share/lsp/roslyn",
            vim.log.levels.WARN
        )
        return
    end

    local settings = {
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
    }

    -- Important: run dotnet from the payload directory so dependency probing works.
    vim.lsp.config.roslyn = {
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
        settings = settings,
    }

    vim.lsp.enable({ "roslyn" })
end

return M
