-- It's important that you set up the plugins in the following order:
-- 1. mason.nvim
-- 2. mason-lspconfig.nvim
-- 3. Setup servers via lspconfig
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		{ "folke/neodev.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp", -- cmp source for lsp
	},
	config = function()
		require("neodev").setup({})

		local lspconfig = require("lspconfig")

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = function(_, bufnr)
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end,
			settings = {
				Lua = {
					hint = {
						enable = true,
					},
				},
			},
		})

		lspconfig["marksman"].setup({
			filetypes = { "markdown", "mdx", "markdoc" },
			capabilities = capabilities,
			on_attach = function()
				-- Search UP for a markdown header
				-- Make sure to follow proper markdown convention, and you have a single H1
				-- heading at the very top of the file
				-- This will only search for H2 headings and above
				vim.keymap.set("n", "gk", function()
					-- `?` - Start a search backwards from the current cursor position.
					-- `^` - Match the beginning of a line.
					-- `##` - Match 2 ## symbols
					-- `\\+` - Match one or more occurrences of prev element (#)
					-- `\\s` - Match exactly one whitespace character following the hashes
					-- `.*` - Match any characters (except newline) following the space
					-- `$` - Match extends to end of line
					vim.cmd("silent! ?^##\\+\\s.*$")
					-- Clear the search highlight
					vim.cmd("nohlsearch")
				end, { desc = "Go to previous markdown header" })

				-- Search DOWN for a markdown header
				-- Make sure to follow proper markdown convention, and you have a single H1
				-- heading at the very top of the file
				-- This will only search for H2 headings and above
				vim.keymap.set("n", "gj", function()
					-- `/` - Start a search forwards from the current cursor position.
					-- `^` - Match the beginning of a line.
					-- `##` - Match 2 ## symbols
					-- `\\+` - Match one or more occurrences of prev element (#)
					-- `\\s` - Match exactly one whitespace character following the hashes
					-- `.*` - Match any characters (except newline) following the space
					-- `$` - Match extends to end of line
					vim.cmd("silent! /^##\\+\\s.*$")
					-- Clear the search highlight
					vim.cmd("nohlsearch")
				end, { desc = "Go to next markdown header" })
			end,
		})

		-- for .json and .jsonc, NOT .json5
		lspconfig["jsonls"].setup({
			capabilities = capabilities,
			-- lazy-load schemastore when needed
			on_new_config = function(new_config)
				new_config.settings.json.schemas = new_config.settings.json.schemas or {}
				vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
			end,
			settings = {
				json = {
					format = {
						enable = true,
					},
					validate = {
						enable = true,
					},
				},
			},
		})

		lspconfig["yamlls"].setup({
			capabilities = capabilities,
			-- lazy-load schemastore when needed
			on_new_config = function(new_config)
				-- Not the same logic as jsonls because yaml schemas are a dict, not a list. https://github.com/LazyVim/LazyVim/commit/33c677a55e97ee115ad7050856856df7cd96b3e1
				new_config.settings.yaml.schemas = vim.tbl_deep_extend(
					"force",
					new_config.settings.yaml.schemas or {},
					require("schemastore").yaml.schemas()
				)
			end,
			settings = {
				redhat = {
					telemetry = {
						enabled = false,
					},
				},
				yaml = {
					format = {
						enable = true,
					},
					validate = true,
					schemaStore = {
						-- You must disable built-in schemaStore support if you want to use
						-- schemas from Schemastore.nvim
						enable = false,
						-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
						url = "",
					},
				},
			},
		})

		-- taplo (lsp for .toml) already has SchemaStore configured
		lspconfig["taplo"].setup({ capabilities = capabilities })

		lspconfig["bashls"].setup({
			capabilities = capabilities,
			filetypes = { "sh", "zsh" },
			settings = {
				-- INFO: options inside bashIde: https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
				bashIde = {
					globPattern = "*@(.sh|.inc|.bash|.command|.zshrc|.zsh|zsh_*)",
				},
			},
		})

		lspconfig["tsserver"].setup({
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- do not enable inlay hints by default in javascript and javascriptreact
				vim.lsp.inlay_hint.enable(string.find(vim.bo.filetype, "javascript") == nil, { bufnr = bufnr })

				-- never format with tsserver
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				-- INFO:  https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#code-actions-on-save
				vim.keymap.set("n", "<leader>cS", function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							---@diagnostic disable-next-line: assign-type-mismatch
							only = { "source.sortImports.ts" },
							diagnostics = {},
						},
					})
				end)

				vim.keymap.set("n", "<leader>cR", function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							---@diagnostic disable-next-line: assign-type-mismatch
							only = { "source.removeUnusedImports.ts" },
							diagnostics = {},
						},
					})
				end)
			end,
			settings = {
				-- INFO: https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
				-- https://github.com/typescript-language-server/typescript-language-server/blob/b224b878652438bcdd639137a6b1d1a6630129e4/src/features/fileConfigurationManager.ts#L89
				typescript = {
					inlayHints = {
						includeInlayEnumMemberValueHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					},
					implementationsCodeLens = {
						enabled = true,
					},
					referencesCodeLens = {
						enabled = true,
						showOnAllFunctions = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayEnumMemberValueHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					},
					implementationsCodeLens = {
						enabled = true,
					},
					referencesCodeLens = {
						enabled = true,
						showOnAllFunctions = true,
					},
				},
				completions = {
					completeFunctionCalls = true,
				},
			},
		})

		lspconfig["ruff"].setup({
			capabilities = capabilities,
		})

		lspconfig["gopls"].setup({
			capabilities = capabilities,
			on_attach = function(_, bufnr)
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end,
			settings = {
				-- INFO: https://github.com/golang/tools/blob/master/gopls/doc/vim.md
				-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
				gopls = {
					gofumpt = true,
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						run_govulncheck = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					-- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
					analyses = {
						fieldalignment = true,
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
					},
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
					semanticTokens = true,
				},
			},
		})

		lspconfig["biome"].setup({
			capabilities = capabilities,
		})

		lspconfig["eslint"].setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- never use eslint as formatter: https://typescript-eslint.io/troubleshooting/formatting/
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll",
				})
			end,
			settings = {
				format = false,
			},
		})

		lspconfig["html"].setup({
			capabilities = capabilities,
		})

		lspconfig["cssls"].setup({
			capabilities = capabilities,
		})

		lspconfig["emmet_language_server"].setup({
			capabilities = capabilities,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
		})

		lspconfig["astro"].setup({
			capabilities = capabilities,
			on_attach = function(_, bufnr)
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end,
      -- FIXME: inlay hints do not work
			-- try to set the same settings as tsserver, https://github.com/withastro/language-tools/blob/main/packages/vscode/README.md#inlay-hints-dont-work
			settings = {
				-- INFO: https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
				-- https://github.com/typescript-language-server/typescript-language-server/blob/b224b878652438bcdd639137a6b1d1a6630129e4/src/features/fileConfigurationManager.ts#L89
				typescript = {
					inlayHints = {
						includeInlayEnumMemberValueHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					},
					implementationsCodeLens = {
						enabled = true,
					},
					referencesCodeLens = {
						enabled = true,
						showOnAllFunctions = true,
					},
				},
				completions = {
					completeFunctionCalls = true,
				},
			},
		})

		-- Global mappings.
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		vim.keymap.set("n", "<space>d", vim.diagnostic.open_float)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
		vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<space>ca", function()
					-- pass in the current line as range, the default is the current cursor position
					vim.lsp.buf.code_action({
						range = {
							start = { vim.fn.line(".") or 0, 0 },
							["end"] = { vim.fn.line(".") or 0, vim.fn.col("$") or 0 },
						},
					})
				end, opts)
				vim.keymap.set("v", "<space>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			end,
		})
	end,
}
