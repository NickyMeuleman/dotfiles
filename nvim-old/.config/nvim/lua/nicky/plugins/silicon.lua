return {
  -- NOTE: replace with https://github.com/mistricky/codesnap.nvim when that supports themes
	"michaelrommel/nvim-silicon",
	lazy = true,
	cmd = "Silicon",
	config = function()
		require("silicon").setup({
			disable_defaults = true,
			language = function()
				return vim.bo.filetype
			end,
			output = function()
				return "~/Pictures/code-screenshots/" .. os.date("!%Y-%m-%dT%H-%M-%S") .. "_code.png"
			end,
		})
	end,
}
