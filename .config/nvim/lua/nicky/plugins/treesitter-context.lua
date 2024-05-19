return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("treesitter-context").setup({
			max_lines = 20,
			multiline_threshold = 5,
		})
	end,
}
