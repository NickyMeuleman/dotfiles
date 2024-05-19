return {
	"mfussenegger/nvim-lint",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"williamboman/mason.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local M = {}

		local lint = require("lint")

		M.conditions = {
			markdownlint = function(ctx)
				return vim.fs.find({
					".markdownlint.json",
					".markdownlint.jsonc",
					".markdownlint.yaml",
					".markdownlint.yml",
				}, { path = ctx.filename, upward = true })[1]
			end,
			yamllint = function(ctx)
				-- https://yamllint.readthedocs.io/en/stable/configuration.html
				local local_config = vim.fs.find({
					".yamllint",
					".yamllint.yaml",
					".yamllint.yml",
				}, { path = ctx.filename, upward = true })[1]

				if not local_config then
					return vim.fs.find("config", { path = vim.env.HOME .. "/.config/yamllint" })[1]
				end

				return local_config
			end,
		}

		-- get filetype with :lua print(vim.bo.filetype)
		-- linter names found in nvim-lint docs
		lint.linters_by_ft = {
			-- don't enable biome or eslint here, their lsp (set in lspconfig) already handles linting, setting it leads to duplicate messages
			markdown = { "markdownlint" },
			mdx = { "markdownlint" },
			markdoc = { "markdownlint" },
			yaml = { "yamllint" },
		}

		-- a function that wraps lint.try_lint so linters can be conditional
		-- modified from https://github.com/LazyVim/LazyVim/blob/8dae76c1fd6fb90199b56cda8b6ec21576d02eb5/lua/lazyvim/plugins/linting.lua#L54
		function M.lint()
			-- Use nvim-lint's logic first:
			-- * checks if linters exist for the full filetype first
			-- * otherwise will split filetype by "." and add all those linters
			-- * this differs from conform.nvim which only uses the first filetype that has a formatter
			local names = lint._resolve_linter_by_ft(vim.bo.filetype)
			-- Create a copy of the names table to avoid modifying the original.
			names = vim.list_extend({}, names)

			-- Add fallback linters.
			if #names == 0 then
				vim.list_extend(names, lint.linters_by_ft["_"] or {})
			end

			-- Add global linters.
			vim.list_extend(names, lint.linters_by_ft["*"] or {})

			-- Filter out linters that don't exist or don't match the condition.
			local ctx = {}
			ctx.filename = vim.api.nvim_buf_get_name(0)
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				local condition = M.conditions[name]

				-- filter non-existant linters
				if not linter then
					vim.print("Linter not found:" .. name, { title = "nvim-lint" })
					return false
				end

				-- allow linters that do not have a condition
				if not condition then
					return true
				end

				-- filter linters based on their condition
				return condition(ctx)
			end, names)

			-- Run linters.
			if #names > 0 then
				lint.try_lint(names)
			end
		end

		-- helper function to ensure the lint function isn't called in quick succession
		function M.debounce(ms, fn)
			local timer = vim.uv.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("lint", { clear = true }),
			callback = M.debounce(100, M.lint),
		})

		vim.keymap.set("n", "<leader>l", M.debounce(100, M.lint), { desc = "Trigger linting for current file" })
	end,
}
