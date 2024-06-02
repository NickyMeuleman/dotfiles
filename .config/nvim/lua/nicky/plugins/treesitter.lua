-- disabling missing-fields warning as nvim-treesitter provides defaults, and certain combinations of fields don't make sense
---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	event = { "BufReadPre", "BufNewFile" },
	keys = function()
		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
		return {
			-- Repeat movement with ; and ,
			-- vim way: ; goes to the direction you were moving.
			{ ";", ts_repeat_move.repeat_last_move, mode = { "n", "x", "o" } },
			{ ",", ts_repeat_move.repeat_last_move_opposite, mode = { "n", "x", "o" } },
			-- retain repeatability of builtin f,F,t,T since they would have been overridden
			{ "f", ts_repeat_move.builtin_f_expr, mode = { "n", "x", "o" }, expr = true },
			{ "F", ts_repeat_move.builtin_F_expr, mode = { "n", "x", "o" }, expr = true },
			{ "t", ts_repeat_move.builtin_t_expr, mode = { "n", "x", "o" }, expr = true },
			{ "T", ts_repeat_move.builtin_T_expr, mode = { "n", "x", "o" }, expr = true },
		}
	end,
	config = function()
		local configs = require("nvim-treesitter.configs")

		-- associate languages without a parser with an existing parser
		vim.treesitter.language.register("markdown", { "markdoc", "mdx" })
		vim.treesitter.language.register("bash", { "zsh" })

		configs.setup({
			-- install grammars for these languages so TS can parse them into a correct AST
			ensure_installed = {
				"astro",
				"bash",
				"bibtex",
				"c",
				"c_sharp",
				"cpp",
				"css",
				"cmake",
				"diff",
				"dockerfile",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"graphql",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"json5",
				"jsonc",
				"just",
				"latex",
				"lua",
				"luadoc",
				"luap",
				"make",
				"markdown",
				"markdown_inline",
				"ninja",
				"prisma",
				"python",
				"query",
				"regex",
				"ron",
				"rst",
				"ruby",
				"rust",
				"svelte",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
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
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm from the textobjects plugin repo
						-- using "a" for parameter to keep "p" for paragraph
						["aa"] = { query = "@parameter.outer", desc = "around parameter" },
						["ia"] = { query = "@parameter.inner", desc = "inner parameter" },
						["ac"] = { query = "@class.outer", desc = "around class" },
						["ic"] = { query = "@class.inner", desc = "inner class" },
						["af"] = { query = "@function.outer", desc = "around function" },
						["if"] = { query = "@function.inner", desc = "inner function" },
					},
				},
				swap = {
					enable = true,
					-- using "a" for parameter again to keep consistency with other textobject keymaps
					-- @attribute.outer swaps HTML attributes, but "a" is already used by parameter, sad noises
					swap_next = {
						["<leader>wa"] = { query = "@parameter.inner", desc = "swap next p[a]rameter" },
						["<leader>wf"] = { query = "@function.outer", desc = "swap next [f]unction" },
						["<leader>wt"] = { query = "@attribute.outer", desc = "swap next a[t]tribute" },
					},
					swap_previous = {
						["<leader>wA"] = { query = "@parameter.inner", desc = "swap previous p[A]rameter" },
						["<leader>wF"] = { query = "@function.outer", desc = "swap previous [F]unction" },
						["<leader>wT"] = { query = "@attribute.outer", desc = "swap previous a[T]tribute" },
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					-- using "a" for parameter again to keep consistency with other textobject keymaps
					-- not using "f" for function because [f and ]f are already goto file
					goto_next_start = {
						["]a"] = { query = "@parameter.inner", desc = "next parameter start" },
						["]m"] = { query = "@function.outer", desc = "next function/method start" },
						["]["] = { query = "@block.outer", desc = "next block start" },
					},
					goto_next_end = {
						["]A"] = { query = "@parameter.inner", desc = "next parameter end" },
						["]M"] = { query = "@function.outer", desc = "next function/method end" },
						["]]"] = { query = "@block.outer", desc = "next block end" },
					},
					goto_previous_start = {
						["[a"] = { query = "@parameter.inner", desc = "previous parameter start" },
						["[m"] = { query = "@function.outer", desc = "previous function/method start" },
						["[["] = { query = "@block.outer", desc = "previous block start" },
					},
					goto_previous_end = {
						["[A"] = { query = "@parameter.inner", desc = "previous parameter end" },
						["[M"] = { query = "@function.outer", desc = "previous function/method end" },
						["[]"] = { query = "@block.outer", desc = "previous block end" },
					},
				},
			},
			-- syntax highlighting based on TS grammars
			highlight = { enable = true },
			-- indentation logic based on TS grammars
			indent = { enable = true },
		})
	end,
}
