return {
	"monaqa/dial.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = function()
		local dial_map = require("dial.map")

		return {
			{
				"<C-a>",
				function()
					dial_map.manipulate("increment", "normal")
				end,
			},
			{
				"<C-x>",
				function()
					dial_map.manipulate("decrement", "normal")
				end,
			},
			{
				"g<C-a>",
				function()
					dial_map.manipulate("increment", "gnormal")
				end,
			},
			{
				"g<C-x>",
				function()
					dial_map.manipulate("decrement", "gnormal")
				end,
			},
			{
				"<C-a>",
				function()
					dial_map.manipulate("increment", "visual")
				end,
				mode = "v",
			},
			{
				"<C-x>",
				function()
					dial_map.manipulate("decrement", "visual")
				end,
				mode = "v",
			},
			{
				"g<C-a>",
				function()
					dial_map.manipulate("increment", "gvisual")
				end,
				mode = "v",
			},
			{
				"g<C-x>",
				function()
					dial_map.manipulate("decrement", "gvisual")
				end,
				mode = "v",
			},
		}
	end,
	config = function()
		local augend = require("dial.augend")

		-- A regular expression used in search.
		-- "\\C" \C forces matching to be case-sensitive
		-- "\\V" This stands for very nomagic.
		-- It’s similar to \M, but even more characters are treated as they are. Only the characters \ and & are treated as special or “magic” characters.
		-- "\\(%s\\)" `%s` represents the string specified in `elements.`
		-- this pattern matches the string in `elements` without vim's "magic" setting in a regex capture group
		local non_word_pattern = "\\C\\V\\(%s\\)"

		-- augend rules that are used multiple times
		local equality = augend.constant.new({
			elements = { "==", "!=" },
			pattern_regexp = non_word_pattern,
		})

		local case_snake_pascal_screamingsnake = augend.case.new({
			types = { "snake_case", "PascalCase", "SCREAMING_SNAKE_CASE" },
		})

		-- all augend rules that do not interfere with eachother, even if they are unused in a language
		local shared_augends = {
			augend.date.alias["%Y-%m-%d"], -- ISO8601 or bust https://xkcd.com/1179/
			augend.integer.alias.decimal,
			augend.integer.alias.hex,
			augend.hexcolor.new({ case = "lower" }),
			augend.hexcolor.new({ case = "upper" }),
			augend.constant.new({
				elements = { "and", "or" },
				word = true, -- (default) if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
				cyclic = true, -- (default) "or" is incremented into "and".
			}),
			-- logical operators
			augend.constant.new({
				elements = { "&&", "||" },
				pattern_regexp = non_word_pattern,
			}),
			augend.constant.new({
				elements = { "let", "const" },
			}),
			-- https://github.com/monaqa/dial.nvim/issues/87
			augend.constant.new({
				elements = { "<", "<=", ">", ">=" },
				-- uses negative lookahead to ensure the empy space does not follow a =
				-- this means patterns like <== will not be matched, but that's not an element anyway, so it doesn't matter
				pattern_regexp = [[\C\M\(%s\)=\@!]],
			}),
			augend.constant.alias.bool,
			augend.constant.new({
				elements = { "True", "False" },
			}),
			--  bitwise operator: does not conflict with the && to || toggle somehow
			augend.constant.new({
				elements = { "&", "^", "|" },
				pattern_regexp = non_word_pattern,
			}),
			-- bitwise operator and assignment
			augend.constant.new({
				elements = { "&=", "^=", "|=" },
				pattern_regexp = non_word_pattern,
			}),
			-- bitwise shift
			augend.constant.new({
				elements = { ">>", "<<" },
				pattern_regexp = non_word_pattern,
			}),
			-- bitwise shift and assignment
			augend.constant.new({
				elements = { ">>=", "<<=" },
				pattern_regexp = non_word_pattern,
			}),
			-- arithmetic operator
			augend.constant.new({
				elements = { "+", "-", "*", "/", "%" },
				pattern_regexp = non_word_pattern,
			}),
			-- arithmetic operator and assignment
			augend.constant.new({
				elements = { "+=", "-=", "*=", "/=", "%=" },
				pattern_regexp = non_word_pattern,
			}),
			augend.misc.alias.markdown_header,
			-- no quote rule here: it interferes with language specific rules (eg. typescript including the backtick)
			-- no bracket rule here: it prevent toggling things inside brackets (eg. for my_function(0), you cannot increment the number because it will toggle brackets instead)
			-- no equality rule here: it interferes (eg. ~= in lua and != in rust etc.)
			-- no case rule here: different conventions in every language
		}

		local ft_specific = {
			javascript = {
				augend.paren.new({
					patterns = { { "'", "'" }, { '"', '"' }, { "`", "`" } },
					nested = false,
					escape_char = [[\]],
					cyclic = true,
				}),
				equality,
				augend.constant.new({
					elements = { "===", "!==" },
					pattern_regexp = non_word_pattern,
				}),
				augend.case.new({
					types = { "camelCase", "PascalCase", "SCREAMING_SNAKE_CASE" },
				}),
			},
			lua = {
				augend.paren.alias.lua_str_literal,
				augend.constant.new({
					elements = { "==", "~=" },
					pattern_regexp = non_word_pattern,
				}),
				case_snake_pascal_screamingsnake,
			},
			python = {
				augend.paren.alias.quote,
				equality,
				case_snake_pascal_screamingsnake,
			},
			markdown = {
				augend.paren.alias.quote,
				equality,
			},
			rust = {
				augend.paren.alias.rust_str_literal,
				equality,
				case_snake_pascal_screamingsnake,
			},
		}

		require("dial.config").augends:register_group({
			default = shared_augends,
		})

		-- the filetype augends replace the augends specified by "register_group" completely
		require("dial.config").augends:on_filetype({
			typescript = vim.list_extend(vim.deepcopy(shared_augends), ft_specific.javascript),
			javascript = vim.list_extend(vim.deepcopy(shared_augends), ft_specific.javascript),
			lua = vim.list_extend(vim.deepcopy(shared_augends), ft_specific.lua),
			python = vim.list_extend(vim.deepcopy(shared_augends), ft_specific.python),
			markdown = vim.list_extend(vim.deepcopy(shared_augends), ft_specific.markdown),
			rust = vim.list_extend(vim.deepcopy(shared_augends), ft_specific.rust),
		})
	end,
}
