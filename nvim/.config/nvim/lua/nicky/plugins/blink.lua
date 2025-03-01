return {
	"saghen/blink.cmp",
	dependencies = {
		"MeanderingProgrammer/render-markdown.nvim",
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	build = "cargo build --release",
	event = "InsertEnter",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<C-p>"] = { "select_prev", "snippet_backward", "fallback_to_mappings" },
			["<C-n>"] = { "select_next", "snippet_forward", "fallback_to_mappings" },
		},
		snippets = { preset = "luasnip" },
		-- NOTE: enable to replace ray-x/lsp_signature.nvim when this becomes stable
		-- https://github.com/Saghen/blink.cmp/issues/1071
		signature = { enabled = false },
		appearance = {
			nerd_font_variant = "mono",
			kind_icons = {
				Constructor = "",
				Function = "󰊕",
				Text = "",
				Method = "",
				Field = "",
				Variable = "",
				Class = "",
				Interface = "",
				Module = "",
				Property = "",
				Unit = "",
				Value = "",
				Enum = "",
				Keyword = "",
				Snippet = "",
				Color = "",
				File = "",
				Reference = "",
				Folder = "",
				EnumMember = "",
				Constant = "",
				Struct = "",
				Event = "",
				Operator = "",
				TypeParameter = "",
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "markdown" },
			providers = {
				markdown = {
					name = "RenderMarkdown",
					module = "render-markdown.integ.blink",
					fallbacks = { "lsp" },
				},
			},
		},
		completion = {
			menu = {
				draw = {
					treesitter = { "lsp" },
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								end
								return icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
						source_name = {
							ellipsis = false,
							text = function(ctx)
								local source_names = {
									["Buffer"] = "[Buff]",
									["LSP"] = "[LSP]",
									["Path"] = "[Path]",
									["Snippets"] = "[Snip]",
                  ["cmdline"] = "[CMD]",
									git = "[Git]",
									emoji = "[Emoji]",
									lazydev = "[Lazy]",
								}
                -- vim.print(ctx.source_name)
                vim.print(ctx.source_id)
								return source_names[ctx.source_name] or ("[" .. ctx.source_name .. "]")
							end,
						},
					},
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind", gap = 1 },
						{ "source_name" },
					},
				},
			},
			accept = { auto_brackets = { enabled = true } },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
		},
		cmdline = {
			completion = { menu = { auto_show = true } },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
