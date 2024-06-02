return {
	"lukas-reineke/indent-blankline.nvim",
	dependencies = {
		"HiPhish/rainbow-delimiters.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- highlight groups need to be defined
		local highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}

		local hooks = require("ibl.hooks")

		-- ensure rainbow-delimiters uses the same colors
		vim.g.rainbow_delimiters = { highlight = highlight }

		require("ibl").setup({
			indent = { char = "▏" },
			scope = { highlight = highlight },
		})

		-- only color currently active scope
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}
