return {
	"HiPhish/rainbow-delimiters.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("rainbow-delimiters.setup").setup({})
	end,
}
