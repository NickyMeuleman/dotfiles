return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown", "mdx", "markdoc", "norg", "org" },
	config = function()
		require("render-markdown").setup({
			sign = { enabled = false },
		})
	end,
}
