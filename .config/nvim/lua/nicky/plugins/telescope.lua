return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-treesitter/nvim-treesitter",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = function()
		local builtin = require("telescope.builtin")
		return {
			{ "<C-p>", builtin.find_files, desc = "Search files" },
			{ "<leader>sf", builtin.find_files, desc = "Search [f]iles" },
			{ "<leader>sg", builtin.live_grep, desc = "Search by [g]rep (text)" },
			{ "<leader>sb", builtin.buffers, desc = "Search [b]uffers" },
			{ "<leader>sh", builtin.help_tags, desc = "Search [h]elp" },
			{ "<leader>st", builtin.git_files, desc = "Search git file [t]ree" },
			{ "<leader>sr", builtin.current_buffer_fuzzy_find, desc = "Search in cu[r]rent buffer" },
			{
				"<leader>sc",
				function()
					vim.api.nvim_exec_autocmds("User", { pattern = "ColorschemeLoad" })
					builtin.colorscheme({
						enable_preview = true,
					})
				end,
				desc = "Search [c]olorschemes",
			},
		}
	end,
	config = function()
		require("telescope").setup({})
		-- loading extesion needs to happen after setup
		require("telescope").load_extension("fzf")
	end,
}
