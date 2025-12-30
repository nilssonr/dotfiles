-- ===============================================================
-- Roslyn (C#) LSP Configuration
-- ===============================================================
local M = {} -- module table

local function payload_dir()
    -- Prefer the self-contained payload dir (has deps.json + System.CommandLine.dll)
    return vim.fn.expand("~/.local/share/lsp/roslyn/content/LanguageServer/osx-arm64") -- Roslyn payload path
end

function M.setup()
    local dir = payload_dir()                                       -- payload directory
    local dll = dir .. "/Microsoft.CodeAnalysis.LanguageServer.dll" -- Roslyn server DLL

    if vim.fn.filereadable(dll) ~= 1 then
        vim.notify(
            "Roslyn LS not found. Expected: " .. dll .. "\nInstall/extract the nupkg to ~/.local/share/lsp/roslyn",
            vim.log.levels.WARN
        )
        return
    end

    -- ===========================================================
    -- Roslyn Settings
    -- ===========================================================
    local settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles", -- analyze open files only
            dotnet_compiler_diagnostics_scope = "openFiles", -- compiler diagnostics for open files
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true, -- show references lens
            dotnet_enable_tests_code_lens = true,      -- show tests lens
        },
        ["csharp|completion"] = {
            dotnet_provide_regex_completions = true,                        -- regex completions
            dotnet_show_completion_items_from_unimported_namespaces = true, -- suggest imports
            dotnet_show_name_completion_suggestions = true,                 -- suggest names
        },
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,                -- object creation hints
            csharp_enable_inlay_hints_for_implicit_variable_types = true,                 -- var type hints
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,                  -- lambda param hints
            csharp_enable_inlay_hints_for_types = true,                                   -- type hints
            dotnet_enable_inlay_hints_for_indexer_parameters = true,                      -- indexer hints
            dotnet_enable_inlay_hints_for_literal_parameters = true,                      -- literal param hints
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,              -- object creation hints
            dotnet_enable_inlay_hints_for_other_parameters = true,                        -- other param hints
            dotnet_enable_inlay_hints_for_parameters = true,                              -- parameter hints
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true, -- suppress suffix hints
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,   -- suppress name matches
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,   -- suppress intent matches
        },
        ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true, -- search reference assemblies
        },
        ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true, -- organize using statements
        },
        razor = {
            language_server = {
                cohosting_enabled = true, -- enable razor cohosting
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
        cmd_cwd = dir,                 -- run in payload directory
        settings = settings,           -- roslyn settings
        filetypes = { "cs", "razor" }, -- file types to attach roslyn to
    }

    vim.lsp.enable({ "roslyn" }) -- enable roslyn server
end

return M
