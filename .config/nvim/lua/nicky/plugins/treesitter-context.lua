return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("treesitter-context").setup({
			max_lines = 20,
			multiline_threshold = 5,
		})
	end,
}
