return {
	"mfussenegger/nvim-lint",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
	config = function()
		local lint = require("lint")

		-- get filetype with :lua print(vim.bo.filetype)
		-- linter names found in nvim-lint docs
		lint.linters_by_ft = {
      -- don't enable biome, the lsp (set in lspconfig) already handles linting, setting it leads to duplicate messages
			-- javascript = { "biomejs" },
      -- TODO: make using eslint conditional
			-- typescript = { "eslint_d" },
			-- javascriptreact = { "eslint_d" },
			-- typescriptreact = { "eslint_d" },
			markdown = { "markdownlint" },
			mdx = { "markdownlint" },
			markdoc = { "markdownlint" },
			-- json = { "biomejs" },
			-- jsonc = { "biomejs" },
			yaml = { "yamllint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
