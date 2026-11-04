vim.g.rustaceanvim = {
	server = {
		on_attach = function(client, bufnr)
			vim.keymap.set("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, { buffer = bufnr, silent = true, desc = "Hover actions" })

			vim.keymap.set("n", "<leader>cd", function()
				vim.cmd.RustLsp("renderDiagnostic")
			end, { buffer = bufnr, silent = true, desc = "Render Diagnostic" })

			vim.keymap.set("n", "<leader>cr", function()
				vim.cmd.RustLsp("runnables")
			end, { buffer = bufnr, silent = true, desc = "Runnables" })

			vim.keymap.set("n", "<leader>ct", function()
				vim.cmd.RustLsp("testables")
			end, { buffer = bufnr, silent = true, desc = "Testables" })
		end,
		-- https://rust-analyzer.github.io/book/configuration
		---@type lspconfig.settings.rust_analyzer
		default_settings = {
			["rust-analyzer"] = {
				cargo = {
					features = "all",
					targetDir = true,
				},
				check = {
					command = "clippy",
					extraArgs = { "--no-deps" },
				},
				completion = {
					fullFunctionSignatures = { enable = true },
				},
				inlayHints = {
					closureReturnTypeHints = { enable = "with_block" },
				},
				diagnostics = {
					experimental = { enable = true },
				},
			},
		},
	},
}

local crates = require("crates")
crates.setup({
	lsp = {
		enabled = true,
		on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, silent = true }

			vim.keymap.set(
				"n",
				"<leader>ct",
				crates.toggle,
				vim.tbl_extend("force", opts, { desc = "Toggle crates UI" })
			)
			vim.keymap.set(
				"n",
				"<leader>cr",
				crates.reload,
				vim.tbl_extend("force", opts, { desc = "Reload crates data" })
			)

			vim.keymap.set(
				"n",
				"<leader>cv",
				crates.show_versions_popup,
				vim.tbl_extend("force", opts, { desc = "Show versions popup" })
			)
			vim.keymap.set(
				"n",
				"<leader>cf",
				crates.show_features_popup,
				vim.tbl_extend("force", opts, { desc = "Show features popup" })
			)
			vim.keymap.set(
				"n",
				"<leader>cd",
				crates.show_dependencies_popup,
				vim.tbl_extend("force", opts, { desc = "Show dependencies popup" })
			)

			vim.keymap.set(
				"n",
				"<leader>cu",
				crates.update_crate,
				vim.tbl_extend("force", opts, { desc = "Update crate" })
			)
			vim.keymap.set(
				"v",
				"<leader>cu",
				crates.update_crates,
				vim.tbl_extend("force", opts, { desc = "Update selected crates" })
			)
			vim.keymap.set(
				"n",
				"<leader>cU",
				crates.upgrade_crate,
				vim.tbl_extend("force", opts, { desc = "Upgrade crate" })
			)
			vim.keymap.set(
				"v",
				"<leader>cU",
				crates.upgrade_crates,
				vim.tbl_extend("force", opts, { desc = "Upgrade selected crates" })
			)

			vim.keymap.set(
				"n",
				"<leader>cA",
				crates.update_all_crates,
				vim.tbl_extend("force", opts, { desc = "Update all crates" })
			)
			vim.keymap.set(
				"n",
				"<leader>cL",
				crates.upgrade_all_crates,
				vim.tbl_extend("force", opts, { desc = "Upgrade all crates" })
			)

			vim.keymap.set(
				"n",
				"<leader>cx",
				crates.expand_plain_crate_to_inline_table,
				vim.tbl_extend("force", opts, { desc = "Expand crate to inline table" })
			)
			vim.keymap.set(
				"n",
				"<leader>cX",
				crates.extract_crate_into_table,
				vim.tbl_extend("force", opts, { desc = "Extract crate into table" })
			)

			vim.keymap.set(
				"n",
				"<leader>cH",
				crates.open_homepage,
				vim.tbl_extend("force", opts, { desc = "Open crate homepage" })
			)
			vim.keymap.set(
				"n",
				"<leader>cR",
				crates.open_repository,
				vim.tbl_extend("force", opts, { desc = "Open crate repository" })
			)
			vim.keymap.set(
				"n",
				"<leader>cD",
				crates.open_documentation,
				vim.tbl_extend("force", opts, { desc = "Open crate documentation" })
			)
			vim.keymap.set(
				"n",
				"<leader>cC",
				crates.open_crates_io,
				vim.tbl_extend("force", opts, { desc = "Open crates.io page" })
			)
		end,
		actions = true,
		completion = true,
		hover = true,
	},
})
