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
	filename = {
		[".env"] = "dotenv",
		[".zshrc"] = "zsh",
		[".zshenv"] = "zsh",
		[".stow-local-ignore"] = "gitignore",
	},
	pattern = {
		[".*/yamllint/config"] = "yaml",
		[".*/.yamlfmt"] = "yaml",
		[".*/bat/config"] = "bash",
		-- eg .env.local
		["%.env%.[%w_.-]+"] = "dotenv",
		-- eg .local.env
		["%.[%w_.-]+%.env"] = "dotenv",
	},
})

vim.fn.sign_define("DiagnosticSignError", { text = "󰅚 ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "󰀪 ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋽 ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶 ", texthl = "DiagnosticSignHint" })

require("nicky.lazy")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 250 })
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})
