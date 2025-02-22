return {
	"folke/snacks.nvim",
	-- WARNING `snacks.nvim` should have a priority of 1000 or higher. Add `priority=1000` to the plugin spec
	priority = 1000,
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		---@class snacks.indent.Config
		---@field enabled? boolean
		indent = {
			indent = {
				enabled = true,
			},
			---@class snacks.indent.animate: snacks.animate.Config
			---@field enabled? boolean
			--- * out: animate outwards from the cursor
			--- * up: animate upwards from the cursor
			--- * down: animate downwards from the cursor
			--- * up_down: animate up or down based on the cursor position
			---@field style? "out"|"up_down"|"down"|"up"
			animate = {
				style = "out",
				easing = "linear",
				duration = {
					step = 20, -- ms per step
					total = 250, -- maximum duration
				},
			},
			---@class snacks.indent.Scope.Config: snacks.scope.Config
			scope = {
				cursor = false,
				hl = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			},
		},
	},
}
