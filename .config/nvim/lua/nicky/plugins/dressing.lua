return {
	"stevearc/dressing.nvim",
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
