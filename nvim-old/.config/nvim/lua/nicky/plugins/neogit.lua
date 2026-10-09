return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
    -- TODO: replace telescope with snacks.picker once possible
    -- https://github.com/NeogitOrg/neogit/pull/1654
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
