return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "frappe",
			integrations = {
				headlines = true,
				neotree = true,
				which_key = true,
				treesitter = true,
				treesitter_context = true,
				rainbow_delimiters = true,
			},
		})
		vim.cmd("colorscheme catppuccin")
	end,
}
