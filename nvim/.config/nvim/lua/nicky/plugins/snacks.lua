-- Terminal Mappings
local function term_nav(dir)
	return function(self)
		return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
			vim.cmd.wincmd(dir)
		end)
	end
end

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
		{
			"<C-p>",
			function()
				Snacks.picker.files()
			end,
			desc = "Search files",
		},
		{
			"<leader>sf",
			function()
				Snacks.picker.files()
			end,
			desc = "Search [f]iles",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Search by [g]rep (text)",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Search [b]uffers",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Search [h]elp",
		},
		{
			"<leader>st",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Search git file [t]ree",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Search in cu[r]rent buffers",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Search [c]olorschemes",
		},
		{
			"<c-/>",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal",
		},
	},
	opts = {
		styles = {
			terminal = {
				bo = {
					filetype = "snacks_terminal",
				},
				wo = {},
				keys = {
					q = "hide",
					gf = function(self)
						local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
						if f == "" then
							Snacks.notify.warn("No file under cursor")
						else
							self:hide()
							vim.schedule(function()
								vim.cmd("e " .. f)
							end)
						end
					end,
					term_normal = {
						"<esc>",
						function(self)
							-- the default fn with timer didn't work, this simpler one does the job
							vim.cmd("stopinsert")
						end,
						mode = "t",
						expr = true,
						desc = "Double escape to normal mode",
					},
				},
			},
		},
		terminal = {
			win = {
				wo = { winbar = "" },
				keys = {
					nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
					nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
					nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
					nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
				},
			},
		},
		toggle = {},
		image = {},
		picker = {},
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
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
