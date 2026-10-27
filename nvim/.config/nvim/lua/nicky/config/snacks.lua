local Snacks = require("snacks")

Snacks.setup({
	picker = {
		actions = require("trouble.sources.snacks").actions,
		win = {
			input = {
				keys = {
					["<c-t>"] = {
						"trouble_open",
						mode = { "n", "i" },
					},
				},
			},
		},
	},
	notifier = {},
	toggle = {},
	words = { enabled = false },
	scope = {},
	indent = {
		scope = {
			hl = {
				"RainbowDelimiterRed",
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterOrange",
				"RainbowDelimiterGreen",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
		},
	},
	lazygit = {},
})

Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uW")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
	.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
	:map("<leader>uC")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Theme" }):map("<leader>ut")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.words():map("<leader>uw")
Snacks.toggle
	.new({
		id = "format_on_save_global",
		name = "Format on save (Global)",
		get = function()
			-- treat unset as true
			return vim.g.format_on_save ~= false
		end,
		set = function(state)
			vim.g.format_on_save = state
		end,
	})
	:map("<leader>uF")
Snacks.toggle
	.new({
		id = "format_on_save_buffer",
		name = "Format on save (Buffer)",
		get = function()
			return vim.b.format_on_save
		end,
		set = function(state)
			if vim.b.format_on_save == nil then
				local effective_state = vim.g.format_on_save ~= false
				vim.b.format_on_save = not effective_state
			else
				vim.b.format_on_save = state
			end
		end,
	})
	:map("<leader>uf")

vim.keymap.set("n", "<leader>un", function()
	Snacks.notifier.hide()
end, { desc = "Dismiss all [n]otifications" })
