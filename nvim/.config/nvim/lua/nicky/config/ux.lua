require("nvim-autopairs").setup({ check_ts = true })

require("nvim-ts-autotag").setup({
	opts = { enable_close_on_slash = true },
	aliases = {
		["mdx"] = "html",
		["markdoc"] = "html",
	},
})
