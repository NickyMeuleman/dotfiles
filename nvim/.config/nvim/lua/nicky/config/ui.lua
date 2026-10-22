vim.opt.termguicolors = true -- enable 24-bit RGB color in the TUI

require("catppuccin").setup({
	flavour = "mocha",
	auto_integrations = true,
})
vim.cmd.colorscheme("catppuccin-nvim")

if vim.g.have_nerd_font then
	local icons = require("mini.icons")
	icons.setup()
	icons.mock_nvim_web_devicons()
end

require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
vim.opt.showmode = false -- statusline already shows this

require("which-key").setup()
require("which-key").add({
	{ "<leader>s", desc = "[s]earch" },
	{ "<leader>u", desc = "[u]i" },
})

require("rainbow-delimiters.setup").setup({})
