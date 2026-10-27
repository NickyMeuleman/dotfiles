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
	{ "<leader>g", desc = "[g]it" },
	{ "<leader>w", desc = "s[w]ap" },
	{ "<leader>x", desc = "[x] Trouble" },
	{ "<leader>c", desc = "[c]ode" },
})

require("rainbow-delimiters.setup").setup({})

require("treesitter-context").setup({ max_lines = 5 })
require("snacks")
	.toggle({
		id = "treesitter_context",
		name = "Treesitter Context",
		get = require("treesitter-context").enabled,
		set = function(state)
			if state then
				require("treesitter-context").enable()
			else
				require("treesitter-context").disable()
			end
		end,
	})
	:map("<leader>uc")

require("render-markdown").setup({
	file_types = { "markdown", "mdx", "markdoc" },
})
