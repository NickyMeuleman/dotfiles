---@diagnostic disable: missing-fields
return {
	"windwp/nvim-ts-autotag",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enable_close_on_slash = true,
			},
			aliases = {
        -- use html because markdown is also aliased to it
				["mdx"] = "html",
				["markdoc"] = "html",
			},
		})
	end,
}
