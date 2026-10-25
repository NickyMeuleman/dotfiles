require("nvim-autopairs").setup({ check_ts = true })

require("nvim-ts-autotag").setup({
	opts = { enable_close_on_slash = true },
	aliases = {
		["mdx"] = "html",
		["markdoc"] = "html",
	},
})

local ai = require("mini.ai")
local gen = require("mini.extra").gen_ai_spec

-- Remap Neovim's `an` / `in` to something else before calling |MiniAi.setup()|: >lua
local copy_keymap = function(mode, from_lhs, to_lhs)
	local keymap = vim.fn.maparg(from_lhs, mode, false, true)
	local rhs = keymap.callback or keymap.rhs
	vim.keymap.set(mode, to_lhs, rhs, { desc = keymap.desc })
end
copy_keymap("x", "an", "<Leader>cs")
copy_keymap("x", "in", "<Leader>cS")

-- treesitter queries come from treesitter-text-objects
ai.setup({
	n_lines = 500,
	custom_textobjects = {
		f = ai.gen_spec.treesitter({
			a = "@function.outer",
			i = "@function.inner",
		}),
		c = ai.gen_spec.treesitter({
			a = "@class.outer",
			i = "@class.inner",
		}),
		o = ai.gen_spec.treesitter({
			a = { "@conditional.outer", "@loop.outer" },
			i = { "@conditional.inner", "@loop.inner" },
		}),
		l = ai.gen_spec.treesitter({
			a = "@block.outer",
			i = "@block.inner",
		}),
		i = gen.indent(),
		g = gen.buffer(),
		-- Replace default 'f' with 'u' for usage
		u = ai.gen_spec.function_call(),
		U = ai.gen_spec.function_call({
			name_pattern = "[%w_]",
		}),
	},
})

local swap = require("nvim-treesitter-textobjects.swap")

local function map_swap(lhs, method, query, desc)
	vim.keymap.set("n", lhs, function()
		swap[method](query)
	end, { desc = desc })
end

map_swap("<leader>wa", "swap_next", "@parameter.inner", "Swap parameter with next")
map_swap("<leader>wA", "swap_previous", "@parameter.inner", "Swap parameter with previous")

map_swap("<leader>wf", "swap_next", "@function.outer", "Swap function with next")
map_swap("<leader>wF", "swap_previous", "@function.outer", "Swap function with previous")

map_swap("<leader>wt", "swap_next", "@attribute.outer", "Swap attribute with next")
map_swap("<leader>wT", "swap_previous", "@attribute.outer", "Swap attribute with previous")

require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })

local move = require("nvim-treesitter-textobjects.move")

local function map_move(keys, query, desc)
	local start_next, end_next, start_prev, end_prev = unpack(keys)

	local targets = {
		[start_next] = { method = "goto_next_start", desc = "Next " .. desc },
		[end_next] = { method = "goto_next_end", desc = "Next " .. desc .. " end" },
		[start_prev] = { method = "goto_previous_start", desc = "Previous " .. desc },
		[end_prev] = { method = "goto_previous_end", desc = "Previous " .. desc .. " end" },
	}

	for lhs, info in pairs(targets) do
		vim.keymap.set({ "n", "x", "o" }, lhs, function()
			move[info.method](query, "textobjects")
		end, { desc = info.desc })
	end
end

-- Mappings: map_move({ "next_start", "next_end", "prev_start", "prev_end" }, query, name)
map_move({ "]a", "]A", "[a", "[A" }, "@parameter.inner", "parameter")
map_move({ "]f", "]F", "[f", "[F" }, "@function.outer", "function definition")
map_move({ "]u", "]U", "[u", "[U" }, "@call.outer", "function call")
map_move({ "]c", "]C", "[c", "[C" }, "@class.outer", "class")
map_move({ "]]", "][", "[[", "[]" }, "@block.outer", "block")

-- search_method: trigger on 'next' if cursor is on start (eg. trigger inside next quotes when cursor is on opening quote)
require("mini.surround").setup({ search_method = "cover_or_next" })
