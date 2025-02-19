return {
	"nvim-tree/nvim-web-devicons",
	lazy = true,
	config = function()
		require("nvim-web-devicons").setup({
			override = {
				mdoc = {
					icon = "",
					cterm_color = "253",
					color = "#dddddd",
					name = "Markdoc",
				},
			},
		})
	end,
}
