return {
	"lewis6991/satellite.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
	},
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("satellite").setup()
	end,
}
