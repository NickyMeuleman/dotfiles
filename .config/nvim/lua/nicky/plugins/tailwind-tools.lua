return {
	"luckasRanarison/tailwind-tools.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	ft = {
		"css",
		"html",
		"svelte",
		"astro",
		"vue",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	config = function()
		require("tailwind-tools").setup({})
	end,
}
