require("mason").setup({ PATH = "prepend" })
-- translate between nvim-lspconfig and mason package names eg lua_ls <-> lua-language-server
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		-- LSP
		"jsonls",
		"just",
		"lua_ls",
		"mdx_analyzer",
		"tailwindcss",
		"taplo",
		"tsc",
		"yamlls",
		-- Formatter
		"biome",
		"sqruff",
		"stylua",
	},
})
