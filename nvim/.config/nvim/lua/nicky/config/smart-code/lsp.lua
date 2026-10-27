local servers = {
	-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
	lua_ls = {
		on_init = function(client)
			client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			-- https://github.com/neovim/nvim-lspconfig/issues/3189
			local runtime_files = vim.tbl_filter(function(dir)
				return not dir:match(vim.fn.stdpath("config") .. "/?a?f?t?e?r?")
			end, vim.api.nvim_get_runtime_file("", true))

			local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
			client.config.settings.Lua = vim.tbl_deep_extend("force", current_settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = { "lua/?.lua", "lua/?/init.lua" },
				},
				workspace = {
					checkThirdParty = false,
					library = runtime_files,
				},
			})
		end,
		---@type lspconfig.settings.lua_ls
		settings = {
			Lua = {
				format = { enable = false }, -- Disable formatting (formatting is done by stylua)
			},
		},
	},
	tsc = {},
	biome = {},
	mdx_analyzer = {},
}

for name, config in pairs(servers) do
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		-- "gra" (Normal and Visual mode) is mapped to |vim.lsp.buf.code_action()|
		opts.desc = "Code actions"
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		-- "gri" is mapped to |vim.lsp.buf.implementation()|
		opts.desc = "Go to implementation"
		-- lowercase "gi" is a default map that enters insert mode where you last exited insert mode, so capital I
		vim.keymap.set("n", "gI", function()
			require("snacks").picker.lsp_implementations()
		end, opts)
		-- "grn" is mapped to |vim.lsp.buf.rename()|
		opts.desc = "Rename"
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		-- "grr" is mapped to |vim.lsp.buf.references()|
		opts.desc = "Show LSP references"
		vim.keymap.set("n", "gr", function()
			require("snacks").picker.lsp_references()
		end, opts)
		-- "grt" is mapped to |vim.lsp.buf.type_definition()|
		opts.desc = "Show LSP t[y]pe definitions"
		-- gt and gT are default tab navigation keymaps, so gy
		vim.keymap.set("n", "gy", function()
			require("snacks").picker.lsp_type_definitions()
		end, opts)
		-- "gO" is mapped to |vim.lsp.buf.document_symbol()|
		opts.desc = "Show LSP symbols"
		vim.keymap.set("n", "<leader>ss", function()
			require("snacks").picker.lsp_symbols()
		end, opts)
		opts.desc = "Show LSP workspace Symbols"
		vim.keymap.set("n", "<leader>sS", function()
			require("snacks").picker.lsp_workspace_symbols()
		end, opts)

		-- "grx" is mapped to |vim.lsp.codelens.run()|
		-- CTRL-S (Insert mode) is mapped to |vim.lsp.buf.signature_help()|
		-- |K| is mapped to |vim.lsp.buf.hover()| unless 'keywordprg' is customized or a custom keymap for `K` exists.

		-- vim.lsp.buf.definition
		opts.desc = "Go to definition"
		vim.keymap.set("n", "gd", function()
			require("snacks").picker.lsp_definitions()
		end, opts)
		-- vim.lsp.buf.declaration
		opts.desc = "Go to declaration"
		vim.keymap.set("n", "gD", function()
			require("snacks").picker.lsp_declarations()
		end, opts)
	end,
})

-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
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
