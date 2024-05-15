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
			-- don't enable biome or eslint here, the lsp (set in lspconfig) already handles linting, setting it leads to duplicate messages
			-- TODO: make all tools conditonal
			-- javascript = { "" },
			-- typescript = { "" },
			-- javascriptreact = { "" },
			-- typescriptreact = { "" },
			markdown = { "markdownlint" },
			mdx = { "markdownlint" },
			markdoc = { "markdownlint" },
			-- json = { "" },
			-- jsonc = { "" },
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
