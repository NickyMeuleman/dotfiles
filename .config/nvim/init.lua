require("nicky.options")
-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = " " -- character that replaces the special <leader> mapping in keybinds
require("nicky.keymaps")

-- allow vim to recognize filetypes it doesn't already know about
vim.filetype.add({
	extension = {
		mdx = "mdx",
		mdoc = "markdoc",
	},
	pattern = {
		[".*/yamllint/config"] = "yaml",
		[".*/.yamlfmt"] = "yaml",
		[".*/bat/config"] = "bash",
	},
})

require("nicky.lazy")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 250 })
	end,
})
