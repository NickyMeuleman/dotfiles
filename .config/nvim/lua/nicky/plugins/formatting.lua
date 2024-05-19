return {
	"stevearc/conform.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"williamboman/mason.nvim",
	},
	event = "InsertLeave",
	config = function()
		local conform = require("conform")

		conform.setup({
			-- https://github.com/stevearc/conform.nvim/blob/master/doc/formatter_options.md
			formatters = {
				injected = {
					options = {
						ignore_errors = true,
						-- Map of treesitter language to file extension
						-- A temporary file name with this extension will be generated during formatting
						-- because some formatters care about the filename.
						lang_to_ext = {
							bash = "sh",
							c_sharp = "cs",
							javascript = "js",
							javascriptreact = "jsx",
							markdoc = "mdoc",
							markdown = "md",
							mdx = "mdx",
							python = "py",
							rust = "rs",
							toml = "toml",
							typescript = "ts",
							typescriptreact = "tsx",
							yaml = "yaml",
						},
						-- By default the formatters in `formatters_by_ft` are used
						-- inlude formatters for languages that are normally formatted by an lsp
						lang_to_formatters = {
							rust = { "rustfmt" },
							toml = { "taplo" },
						},
					},
				},
				prettier = {
					condition = function(ctx)
						-- does not take into account the `prettier` key in `package.json`
						return vim.fs.find({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yml",
							".prettierrc.yaml",
							".prettierrc.json5",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.mjs",
							".prettierrc.toml",
							"prettier.config.js",
							"prettier.config.cjs",
							"prettier.config.mjs",
						}, { path = ctx.filename, upward = true })[1]
					end,
					options = {
						-- make prettier aware of filetypes it can parse but aren't automatically inferred
						ft_parsers = {
							json5 = "json",
							markdoc = "markdown",
							mdx = "mdx",
						},
					},
				},
				["biome-check"] = {
					condition = function(ctx)
						return vim.fs.find({
							"biome.json",
							"biome.jsonc",
						}, { path = ctx.filename, upward = true })[1]
					end,
				},
				yamlfmt = {
					condition = function(ctx)
						-- https://github.com/google/yamlfmt/blob/main/docs/config-file.md
						local local_config = vim.fs.find({
							".yamlfmt",
							"yamlfmt.yml",
							"yamlfmt.yaml",
							".yamlfmt.yaml",
							".yamlfmt.yml",
						}, { path = ctx.filename, upward = true })[1]

						if not local_config then
							return vim.fs.find(".yamlfmt", { path = vim.env.HOME .. "/.config/yamlfmt" })[1]
						end

						return local_config
					end,
				},
			},
			-- get filetype with :lua print(vim.bo.filetype)
			-- formatters found in conform docs
			-- use prettier over prettierd, folke is smart, I trust him https://github.com/LazyVim/LazyVim/commit/57b504b9e8ae95c294c17e97e7f017f6f802ebbc
			-- use biome-check explicitly as the builtin lsp formatter biome provides does not perform automatic safe fixes, and biome-check does
			-- formatters listed in an inner list: only the first available one is used
			-- formatters listed in the outer list: the formatters are applied sequentially
			formatters_by_ft = {
				astro = { "prettier" },
				go = { "goimports", "gofumpt" },
				lua = { "stylua" },
				-- only apply one linter eg:
				-- - if biome is used for ts, and prettier is used for md then do not try to use prettier for ts
				-- - but still allow projects that use prettier for ts (biome.json will not exists and biome will not be available)
				javascript = { { "biome-check", "prettier" } },
				typescript = { { "biome-check", "prettier" } },
				javascriptreact = { { "biome-check", "prettier" } },
				typescriptreact = { { "biome-check", "prettier" } },
				markdown = { "prettier", "injected" },
				-- prettier v3 does not support mdx v2/3 fully yet: https://github.com/prettier/prettier/issues/12209
				-- but I use it anyway, because not having formatting is a pain. Only multiline comments seem to be weird.
				mdx = { "prettier", "injected" },
				markdoc = { "prettier", "injected" },
				json = { "biome-check" },
				jsonc = { "biome-check" },
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
