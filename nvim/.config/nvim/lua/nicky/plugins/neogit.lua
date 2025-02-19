return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	cmd = {
		"Neogit",
		"DiffviewOpen",
	},
	keys = {
		{
			"<leader>gn",
			"<cmd>Neogit<cr>",
			desc = "[n]eogit",
		},
	},
	config = function()
		require("neogit").setup({
			---@diagnostic disable-next-line: assign-type-mismatch
			kind = "replace",
		})
	end,
}
