return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- source for luasnip
		"hrsh7th/cmp-buffer", -- source for buffer words
		"hrsh7th/cmp-path", -- source for file paths
		"hrsh7th/cmp-cmdline", -- source for `:` command line
		"hrsh7th/cmp-nvim-lsp", -- source for lsp
		"nvim-lua/plenary.nvim", -- required for git source
		"petertriho/cmp-git", -- source for git commits (looks at github)
		"luckasRanarison/tailwind-tools.nvim", -- colors for tailwind classes
		"hrsh7th/cmp-emoji", -- source for emoji
		"folke/lazydev.nvim", -- source for neovim
	},
	event = {
		"InsertEnter",
		"CmdlineEnter",
	},
	config = function()
		local cmp = require("cmp")
		local ls = require("luasnip")

		local kind_icons = {
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
		}
		local source_names = {
			buffer = "[Buff]",
			nvim_lsp = "[LSP]",
			path = "[Path]",
			luasnip = "[Snip]",
			git = "[Git]",
			emoji = "[Emoji]",
			lazydev = "[Lazy]",
		}

		local mapping_next_snip_cmp = function()
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
			elseif ls.locally_jumpable(1) then
				ls.jump(1)
			else
				cmp.complete()
			end
		end
		local mapping_prev_snip_cmp = function()
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
			elseif ls.locally_jumpable(-1) then
				ls.jump(-1)
			else
				cmp.complete()
			end
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				fields = { "abbr", "kind", "menu" },
				format = function(entry, item)
					item = require("tailwind-tools.cmp").lspkind_format(entry, item)

					item.menu = source_names[entry.source.name]
					if entry.source.name == "emoji" then
						item.kind = ""
					else
						item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)
					end

					return item
				end,
			},
			mapping = {
				["<C-b>"] = cmp.mapping({ i = cmp.mapping.scroll_docs(-4) }),
				["<C-f>"] = cmp.mapping({ i = cmp.mapping.scroll_docs(4) }),
				["<C-space>"] = cmp.mapping({ i = cmp.mapping.complete() }),
				["<C-n>"] = cmp.mapping({
					i = mapping_next_snip_cmp,
					s = mapping_next_snip_cmp,
					c = mapping_next_snip_cmp,
				}),
				["<C-p>"] = cmp.mapping({
					i = mapping_prev_snip_cmp,
					s = mapping_prev_snip_cmp,
					c = mapping_next_snip_cmp,
				}),
				["<C-y>"] = cmp.mapping({
					i = cmp.mapping.confirm({ select = true }),
					c = cmp.mapping.confirm({ select = true }),
				}),
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
			},
			-- cmp.config.sources is a tuple that holds tuples
			-- the top layer determines the priority of groups
			-- the order within a group determines the order in the completion results.
			-- only the group with the higherst priority will be shown
			sources = cmp.config.sources({
				{ name = "luasnip" },
				{ name = "lazydev" },
				{ name = "nvim_lsp" },
				{ name = "path" },
				{ name = "buffer" },
				{ name = "emoji", insert = true }, -- trigger char is :
			}),
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})

		require("cmp_git").setup({
			filetypes = { "gitcommit", "NeogitCommitMessage" },
		})

		cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
			sources = cmp.config.sources({
				{ name = "luasnip" },
				{ name = "git" },
				{ name = "buffer" },
			}),
		})

		-- make the menu text (source) muted
		vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "CmpItemMenuDefault" })
	end,
}
