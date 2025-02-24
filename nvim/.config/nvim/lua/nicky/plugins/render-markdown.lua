-- TODO: setup completions once switched from cmp to blink
-- https://github.com/MeanderingProgrammer/render-markdown.nvim?tab=readme-ov-file#blinkcmp
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown", "mdx", "markdoc", "norg", "org" },
	config = function()
		require("render-markdown").setup({
      sign = { enabled = false },
		})
	end,
}
