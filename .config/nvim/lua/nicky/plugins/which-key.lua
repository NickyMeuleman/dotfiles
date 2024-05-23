return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true -- time out if keys from a combo are not pressed in time
		vim.o.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
	end,
	config = function()
		require("which-key").setup({})
	end,
}
