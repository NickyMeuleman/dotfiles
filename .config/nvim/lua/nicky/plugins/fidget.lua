return {
	"j-hui/fidget.nvim",
	config = function()
		require("fidget").setup({
			progress = {
				lsp = {
					-- https://github.com/j-hui/fidget.nvim/issues/201
					progress_ringbuf_size = 2048,
				},
				display = {
					-- hide messages that have been shown for a long time
					progress_ttl = 180,
				},
			},
		})
	end,
}
