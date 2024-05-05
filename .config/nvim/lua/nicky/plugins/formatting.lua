return {
	"stevearc/conform.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				-- make prettier aware of filetypes it can parse but aren't automatically inferred
				-- https://github.com/stevearc/conform.nvim/blob/master/doc/formatter_options.md
				prettier = {
					options = {
						ft_parsers = {
							json5 = "json",
							markdoc = "markdown",
							mdx = "mdx",
						},
					},
				},
			},
			-- get filetype with :lua print(vim.bo.filetype)
			-- formatters found in conform docs
			-- use prettier over prettierd, folke is smart, I trust him https://github.com/LazyVim/LazyVim/commit/57b504b9e8ae95c294c17e97e7f017f6f802ebbc
			-- formatters listed in an inner list: only the first available one is used
			-- formatters listed in the outer list: the formatters are applied sequentially
			formatters_by_ft = {
				lua = { "stylua" },
				-- biome is used automatically by the biome lsp, but setting it here explicitly so the "injected" conform formatter uses it in codesnippets
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				markdown = { "prettier", "injected" },
				-- prettier v3 does not support mdx v2/3 fully yet: https://github.com/prettier/prettier/issues/12209
				-- but I use it anyway, because not having formatting is a pain. Only multiline comments seem to be weird.
				mdx = { "prettier", "injected" },
				markdoc = { "prettier", "injected" },
				-- rust-analyzer uses this automatically, it's here explicit so the "injected" conform formatter uses it in codesnippets
				rust = { "rustfmt" },
				json = { "biome" },
				jsonc = { "biome" },
				json5 = { "prettier" },
				yaml = { "yamlfmt" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range" })
	end,
}
