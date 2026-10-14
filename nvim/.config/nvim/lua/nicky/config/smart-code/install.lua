require("mason").setup()
-- translate between nvim-lspconfig and mason package names eg lua_ls <-> lua-language-server
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		-- LSP
		"lua_ls",
		-- Formatter
		"stylua",
	},
})
