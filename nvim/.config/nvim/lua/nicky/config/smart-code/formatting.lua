require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
	default_format_opts = { lsp_format = "fallback" },
	format_on_save = function(bufnr)
		-- Check buffer-local flag first; if nil, check global flag.
		local global_enabled = vim.g.format_on_save ~= false
		local buf_enabled = vim.b[bufnr].format_on_save

		if buf_enabled == false or (buf_enabled == nil and not global_enabled) then
			return
		end

		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })
