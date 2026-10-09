return {
	"ray-x/lsp_signature.nvim",
	-- event = "LspAttach", -- does not work
	event = "BufRead",
	dependencies = { "neovim/nvim-lspconfig" },
	config = function()
		require("lsp_signature").setup({
			hint_enable = false,
		})
	end,
}
