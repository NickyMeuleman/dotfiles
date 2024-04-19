return {
	"stevearc/dressing.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
    dependencies = {
		"nvim-lua/plenary.nvim",
    }
	},
	config = function()
		require("dressing").setup({
			input = {
				enabled = true,
			},
			select = {
				enabled = true,
				backend = { "telescope", "builtin" },
			},
		})
	end,
}
