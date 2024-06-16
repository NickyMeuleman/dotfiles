return {
	"windwp/nvim-autopairs",
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	event = { "InsertEnter", "CmdlineEnter" },
	config = function()
		local npairs = require("nvim-autopairs")

		npairs.setup({
			check_ts = true,
		})

		-- inserts a ( after completing methods or functions with a completion so you don't have to type the parentheses
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
