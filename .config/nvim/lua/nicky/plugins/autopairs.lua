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

		-- NOTE: the default values to ignore autopairing when `check_ts = true` are:
		--     ts_config = {
		--      lua = { 'string', 'source', 'string_content' },
		--      javascript = { 'string', 'template_string' },
		--     },
		-- However these settings do NOT work for me, even when explicit.
		-- Sometimes, it correctly doesn't place autopairs in lua strings,
		-- next time, it places them anyway, very annoying, no idea how to fix
		-- it appear to work the first time you try it, and break from the second time on any string, maybe it thinks treesitter turned off?

		-- inserts a ( after completing methods or functions with a completion so you don't have to type the parentheses
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
