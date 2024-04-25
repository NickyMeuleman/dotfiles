return {
	"nvim-tree/nvim-web-devicons",
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
