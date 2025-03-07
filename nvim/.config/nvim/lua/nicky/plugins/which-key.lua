return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true -- time out if keys from a combo are not pressed in time
		vim.o.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
	end,
	config = function()
		local wk = require("which-key")

		wk.add({
			{ "<leader>b", desc = "de[b]ugging" },
			{ "<leader>c", desc = "[c]ode" },
			{ "<leader>g", desc = "[g]it" },
			{ "<leader>h", desc = "[h]arpoon" },
			{ "<leader>s", desc = "[s]earch" },
			{ "<leader>t", desc = "[t]est" },
			{ "<leader>u", desc = "[u]i" },
			{ "<leader>w", desc = "s[w]ap" },
			{ "<leader>x", desc = "[x] trouble" },
		})

		wk.setup({})
	end,
}
