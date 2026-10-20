vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	-- v2 is still unstable (2026-10)
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/refractalize/oil-git-status.nvim",
	"https://github.com/dmtrKovalenko/fff",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/folke/which-key.nvim",
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end

		if name == "fff" then
			if not ev.data.active then
				vim.cmd.packadd("fff")
			end
			require("fff.download").download_or_build_binary()
			return
		end

		if name == "nvim-treesitter" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
			return
		end
	end,
})
