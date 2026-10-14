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
}

for name, config in pairs(servers) do
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end
