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
