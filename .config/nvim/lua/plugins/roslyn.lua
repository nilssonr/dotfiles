return {
	"seblj/roslyn.nvim",
	ft = "cs",
	opts = {
		config = {
			settings = {
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
				["csharp|symbol_search"] = {
					dotnet_search_reference_assemblies = true,
				},
				["csharp|completion"] = {
					dotnet_show_completion_items_from_unimported_namespaces = true,
					dotnet_show_name_completion_suggestions = true,
					dotnet_provide_regex_completions = true,
				},
			},
		},
	},
}
