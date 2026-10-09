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
		require("neo-tree").setup({
			close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
			filesystem = {
				filtered_items = {
					visible = true, -- show dotfiles and gitignored files
				},
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function(file_path)
            -- close neo-tree afte a file is opened
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		})
	end,
}
