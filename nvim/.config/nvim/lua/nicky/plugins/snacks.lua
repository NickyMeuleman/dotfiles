return {
	"folke/snacks.nvim",
	-- WARNING `snacks.nvim` should have a priority of 1000 or higher. Add `priority=1000` to the plugin spec
	priority = 1000,
	opts = {
		---@class snacks.indent.Config
		---@field enabled? boolean
		indent = {
			indent = {
				enabled = true,
			},
			---@class snacks.indent.animate: snacks.animate.Config
			---@field enabled? boolean
			--- * out: animate outwards from the cursor
			--- * up: animate upwards from the cursor
			--- * down: animate downwards from the cursor
			--- * up_down: animate up or down based on the cursor position
			---@field style? "out"|"up_down"|"down"|"up"
			animate = {
				style = "out",
				easing = "linear",
				duration = {
					step = 20, -- ms per step
					total = 250, -- maximum duration
				},
			},
			---@class snacks.indent.Scope.Config: snacks.scope.Config
			scope = {
				cursor = false,
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
		dashboard = {
			formats = {
				key = function(item)
					return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
				end,
				file = function(item, ctx)
					-- TODO: make prefix stripping configurable
					local prefix = vim.fn.getcwd()
					local fname = item.file
					local stripped_prefix = false

					if fname:sub(1, #prefix) == prefix then
						stripped_prefix = true
						fname = "." .. fname:sub(#prefix + 1)
					end
					if not stripped_prefix then
						fname = vim.fn.fnamemodify(fname, ":~")
					end

					fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
					if #fname > ctx.width then
						local dir = vim.fn.fnamemodify(fname, ":h")
						local file = vim.fn.fnamemodify(fname, ":t")
						if dir and file then
							file = file:sub(-(ctx.width - #dir - 2))
							fname = dir .. "/…" .. file
						end
					end
					local dir, file = fname:match("^(.*)/(.+)$")
					return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
				end,
			},
			sections = {
				{
					text = {
						[[
███╗   ██╗██╗ ██████╗██╗  ██╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║██╔════╝██║ ██╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
██╔██╗ ██║██║██║     █████╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
██║╚██╗██║██║██║     ██╔═██╗   ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║██║╚██████╗██║  ██╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
						hl = "SnacksDashboardHeader",
					},
				},
				{
					text = {
						{ "Recent in ", hl = "SnacksDashboardTitle" },
						{ vim.fn.fnamemodify(vim.fn.getcwd(), ":~") .. "/", hl = "SnacksDashboardDir" },
					},
					padding = 1,
				},
				{ section = "recent_files", cwd = true, limit = 5, padding = 1 },
				{ text = { "Recent globally", hl = "SnacksDashboardTitle" }, padding = 1 },
				{ section = "recent_files", limit = 5, padding = 1 },
				function()
					local M = require("snacks.dashboard")
					M.lazy_stats = M.lazy_stats and M.lazy_stats.startuptime > 0 and M.lazy_stats
						or require("lazy.stats").stats()
					local ms = (math.floor(M.lazy_stats.startuptime * 100 + 0.5) / 100)
					return {
						align = "center",
						text = {
							{ " ", hl = "SnacksDashboardIcon" },
							{ "Neovim loaded ", hl = "SnacksDashboardFooter" },
							{ M.lazy_stats.loaded .. "/" .. M.lazy_stats.count, hl = "SnacksDashboardSpecial" },
							{ " plugins in ", hl = "SnacksDashboardFooter" },
							{ ms .. "ms", hl = "SnacksDashboardSpecial" },
						},
					}
				end,
				{
					align = "center",
					text = {
						{ " ", hl = "SnacksDashboardIcon" },
						{ vim.fn.strftime("%Y-%m-%d"), hl = "SnacksDashboardFooter" },
						{ " " },
						{ " ", hl = "SnacksDashboardIcon" },
						{ vim.fn.strftime("%H:%M:%S"), hl = "SnacksDashboardFooter" },
					},
				},
			},
		},
	},
}
