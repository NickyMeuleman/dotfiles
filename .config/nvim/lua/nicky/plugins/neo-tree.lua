return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{
			"<leader>e",
			":Neotree toggle=true source=filesystem reveal=true position=right<CR>",
			desc = "open file tree [e]xplorer",
		},
	},
	config = function()
		require("neo-tree").setup({})
	end,
}
