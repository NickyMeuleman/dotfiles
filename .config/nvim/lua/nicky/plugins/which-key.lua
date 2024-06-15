return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true -- time out if keys from a combo are not pressed in time
		vim.o.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
	end,
	config = function()
		local wk = require("which-key")

		wk.register({
			b = "de[b]ugging",
			c = "[c]ode",
			g = "[g]it",
			h = "[h]arpoon",
			s = "[s]earch",
			t = "[t]est",
			w = "s[w]ap",
			x = "[x] trouble",
		}, { prefix = "<leader>" })

		wk.setup({})
	end,
}
