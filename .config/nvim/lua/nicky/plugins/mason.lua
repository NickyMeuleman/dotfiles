return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonInstallAll",
			"MasonUpdate",
		},
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		cmd = {
			"LspInstall",
			"LspUninstall",
		},
		config = function()
			-- uses lspconfig specific names
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- language servers
					"lua_ls",
					"rust_analyzer",
					"marksman",
					"jsonls",
					"yamlls",
					"taplo",
					"biome", -- also a linter and a formatter
					"bashls", -- uses the shellcheck linter internally
					"tsserver",
					"ruff",
					"gopls",
					"html",
					"cssls",
					"tailwindcss",
					"emmet_language_server",
					"astro",
					"eslint", -- linter implemented as lsp
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = {
			"MasonToolsInstall",
			"MasonToolsUpdate",
		},
		config = function()
			-- uses mason specific names
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- formatters
					"stylua",
					"prettier",
					"yamlfmt",
					"shfmt",
					"goimports",
					"gofumpt",
					-- linters
					"markdownlint",
					"yamllint",
					"shellcheck",
					-- debug adapters
					"codelldb",
					"js-debug-adapter",
				},
			})
		end,
	},
}
