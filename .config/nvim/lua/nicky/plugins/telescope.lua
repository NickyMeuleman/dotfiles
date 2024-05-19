return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = function()
		local builtin = require("telescope.builtin")
		return {
			{ "<C-p>", builtin.find_files },
			{ "<leader>sf", builtin.find_files },
			{ "<leader>sg", builtin.live_grep },
			{ "<leader>sb", builtin.buffers },
			{ "<leader>sh", builtin.help_tags },
			{
				"<leader>sc",
				function()
					builtin.colorscheme({
						enable_preview = true,
					})
				end,
			},
		}
	end,
	config = function()
		require("telescope").setup({})
	end,
}
