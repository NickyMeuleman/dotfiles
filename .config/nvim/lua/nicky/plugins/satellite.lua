return {
	"lewis6991/satellite.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		require("satellite").setup()
	end,
}
