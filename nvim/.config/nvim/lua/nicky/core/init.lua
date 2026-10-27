require("nicky.core.options")
require("nicky.core.keymaps")
require("nicky.core.autocmds")

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	severity_sort = true,
	float = { border = "rounded", style = "minimal", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },
	virtual_text = true,
	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
})
