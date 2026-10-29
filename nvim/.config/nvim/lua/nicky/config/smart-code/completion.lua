-- https://cmp.saghen.dev/recipes.html#completion-menu-drawing
local function get_mini_icon(ctx)
	if ctx.source_name == "Path" then
		local is_unknown_type =
			vim.tbl_contains({ "link", "socket", "fifo", "char", "block", "unknown" }, ctx.item.data.type)
		local mini_icon, mini_hl, _ = require("mini.icons").get(
			is_unknown_type and "os" or ctx.item.data.type,
			is_unknown_type and "" or ctx.label
		)
		if mini_icon then
			return mini_icon, mini_hl
		end
	end
	local mini_icon, mini_hl, _ = require("mini.icons").get("lsp", ctx.kind)
	return mini_icon, mini_hl
end

---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
	completion = {
		documentation = { auto_show = true },
		menu = {
			draw = {
				treesitter = { "lsp" },
				components = {
					kind_icon = {
						text = function(ctx)
							local hex = require("blink.cmp.sources.lsp.hacks.tailwind").get_hex_color(ctx.item)
							if hex then
								return "󱓻"
							end
							local icon, _ = get_mini_icon(ctx)
							return icon or "󰆧"
						end,
						highlight = function(ctx)
							local hex = require("blink.cmp.sources.lsp.hacks.tailwind").get_hex_color(ctx.item)
							if hex then
								local hl = "BlinkTwColor_" .. hex:gsub("#", "")
								if vim.fn.hlID(hl) == 0 then
									vim.api.nvim_set_hl(0, hl, { fg = hex, default = true })
								end
								return hl
							end
							local _, hl = get_mini_icon(ctx)
							return hl or ("BlinkCmpKind" .. ctx.kind)
						end,
					},
					kind = {
						highlight = function(ctx)
							local _, hl = get_mini_icon(ctx)
							return hl
						end,
					},
				},
			},
		},
	},
	signature = { enabled = true },
	cmdline = { completion = { menu = { auto_show = true } } },
})
