return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	dependencies = {
		"rafamadriz/friendly-snippets", -- collection of snippets
	},
	event = {
		"InsertEnter",
		"CmdlineEnter",
	},
	keys = function()
		local ls = require("luasnip")
		return {
			{
				"<C-k>",
				function()
					if ls.expand_or_jumpable() then
						ls.expand_or_jump()
					end
				end,
				mode = { "i", "s" },
				silent = true,
				desc = "Next in snippet (expand or jump)",
			},
			{
				"<C-j>",
				function()
					if ls.jumpable(-1) then
						ls.jump(-1)
					end
				end,
				mode = { "i", "s" },
				silent = true,
				desc = "Prev in snippet (jump)",
			},
			{
				"<C-l>",
				function()
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end,
				mode = { "i", "s" },
				silent = true,
				desc = "Next snippet choice",
			},
		}
	end,
	config = function()
		local ls = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load()

		-- treat certain filetypes as others
		require("luasnip").filetype_extend("mdx", { "markdown" })
		require("luasnip").filetype_extend("markdoc", { "markdown" })

		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node
		local fmt = require("luasnip.extras.fmt").fmt
		local types = require("luasnip.util.types")

		ls.add_snippets("lua", {
			s(
				{
					trig = "fu",
					name = "function",
					desc = "function with newline at the end",
				},
				fmt(
					[[
        function {}({})
          {}          
        end
        {}
        ]],
					{ i(1, "name"), i(2, "arg"), i(3, "-- body"), i(0) }
				)
			),
		})

		ls.setup({
			-- allow jumping back into last snippet after leaving it
			history = true,
			-- update on every change (useful to see changes in dynamic snippets)
			update_events = { "TextChanged", "TextChangedI" },
			enable_autosnippets = true,
			-- Snippets are not automatically removed when their text is deleted.
			-- determine on which events (:h events) a check for deleted snippets is performed.
			-- especially useful if `history` is enabled.
			delete_check_events = "TextChanged",
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { " snippet", "LspInlayHint" } },
					},
				},
				[types.insertNode] = {
					active = {
						virt_text = { { " snippet", "LspInlayHint" } },
					},
				},
			},
		})
	end,
}