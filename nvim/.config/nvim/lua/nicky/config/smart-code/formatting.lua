require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
	default_format_opts = { lsp_format = "fallback" },
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })
