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
				-- a bug with an update requires this now
				automatic_enable = false,
				ensure_installed = {
					-- language servers
					"astro",
					"bashls", -- uses the shellcheck linter internally
					"biome", -- also a linter and a formatter
					"cssls",
					"clangd",
					"emmet_language_server", -- webdev snippet engine
					"eslint", -- linter implemented as lsp
					"gopls",
					"html",
					"jsonls",
					"lua_ls",
					"marksman", -- markdown
					"pyright",
					"ruff", -- python
					"rust_analyzer",
					"sqls",
					"tailwindcss",
					"taplo", -- toml
					"vtsls", -- javascript/typescript
					"yamlls",
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
					"sql-formatter",
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
