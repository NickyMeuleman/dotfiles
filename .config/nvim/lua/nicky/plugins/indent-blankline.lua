return {
	"lukas-reineke/indent-blankline.nvim",
	dependencies = {
		"HiPhish/rainbow-delimiters.nvim",
	},
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- use same highlight groups as the rainbow-delimiter plugins
		-- this way the brackets that delimit a scope in many languages has the same colour as its indentline
		local highlight = {
			"RainbowDelimiterRed",
			"RainbowDelimiterYellow",
			"RainbowDelimiterBlue",
			"RainbowDelimiterOrange",
			"RainbowDelimiterGreen",
			"RainbowDelimiterViolet",
			"RainbowDelimiterCyan",
		}

		local hooks = require("ibl.hooks")

		vim.g.rainbow_delimiters = { highlight = highlight }

		require("ibl").setup({
			enabled = true,
			indent = { char = "▏" },
			scope = { highlight = highlight },
		})

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}
