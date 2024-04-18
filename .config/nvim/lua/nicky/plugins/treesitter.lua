-- disabling missing-fields warning as nvim-treesitter provides defaults, and certain combinations of fields don't make sense
---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			-- install grammars for these languages so TS can parse them into a correct AST
			ensure_installed = {
				"astro",
				"bash",
				"c",
				"css",
				"dockerfile",
				"gitignore",
				"graphql",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"prisma",
				"query",
				"ron",
				"rust",
				"svelte",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			-- automatically install grammars for opened files without one
			auto_install = true,
			-- (visual) selection based on TS grammars
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false, -- disable scope keymap
					node_decremental = "<bs>",
				},
			},
			-- syntax highlighting based on TS grammars
			highlight = { enable = true },
			-- indentation logic based on TS grammars
			indent = { enable = true },
			-- automatically close html-ish tags
			autotag = { enable = true },
		})
	end,
}
