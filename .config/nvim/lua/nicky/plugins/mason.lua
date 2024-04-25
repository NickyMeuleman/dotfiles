return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = {
				-- language servers
				"lua_ls",
				"rust_analyzer",
        "marksman"
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				-- formatters
				"stylua",
        "prettier",
				-- linters
				"eslint_d",
        "markdownlint",
				-- debug adapters
				"codelldb",
			},
		})
	end,
}
