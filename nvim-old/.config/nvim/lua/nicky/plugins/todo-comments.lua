return {
	"folke/todo-comments.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = { "TodoTrouble" },
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{
			"]t",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Next todo comment",
		},
		{
			"[t",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Previous todo comment",
		},
	},
	config = function()
		require("todo-comments").setup({
			keywords = {
				FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				HACK = { icon = " ", color = "warning" },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				PERF = { icon = " ", color = "perf", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
				TODO = { icon = " ", color = "info" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			},
			colors = {
				error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
				warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
				info = { "DiagnosticInfo", "#2563EB" },
				hint = { "DiagnosticHint", "#10B981" },
				default = { "Identifier", "#7C3AED" },
				test = { "Identifier", "#FF00FF" },
				perf = { "@conditional", "#CBA6F7" },
			},
		})
	end,
}
-- FIX:
-- multiline test
-- WARN:
-- multiline test
-- TEST:
-- multiline test
-- HACK:
-- multiline test
-- TODO:
-- multiline test
-- NOTE:
-- multiline test
-- PERF:
-- multiline test
