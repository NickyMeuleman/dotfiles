return {
	"folke/snacks.nvim",
	-- WARNING `snacks.nvim` should have a priority of 1000 or higher. Add `priority=1000` to the plugin spec
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>gl",
			function()
				Snacks.lazygit()
			end,
			desc = "[L]azyGit",
		},
	},
	opts = {
		notifier = {},
		input = {},
		lazygit = {},
		---@class snacks.indent.Config
		---@field enabled? boolean
		indent = {
			indent = { enabled = true },
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
	config = function(_, opts)
		require("snacks").setup(opts)
    -- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md#-examples
		---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
		local progress = vim.defaulttable()
		vim.api.nvim_create_autocmd("LspProgress", {
			---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
				if not client or type(value) ~= "table" then
					return
				end
				local p = progress[client.id]

				for i = 1, #p + 1 do
					if i == #p + 1 or p[i].token == ev.data.params.token then
						p[i] = {
							token = ev.data.params.token,
							msg = ("[%3d%%] %s%s"):format(
								value.kind == "end" and 100 or value.percentage or 100,
								value.title or "",
								value.message and (" **%s**"):format(value.message) or ""
							),
							done = value.kind == "end",
						}
						break
					end
				end

				local msg = {} ---@type string[]
				progress[client.id] = vim.tbl_filter(function(v)
					return table.insert(msg, v.msg) or not v.done
				end, p)

				local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
				vim.notify(table.concat(msg, "\n"), "info", {
					id = "lsp_progress",
					title = client.name,
					opts = function(notif)
						notif.icon = #progress[client.id] == 0 and " "
							or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
					end,
				})
			end,
		})
	end,
}
