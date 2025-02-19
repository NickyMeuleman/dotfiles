return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local opts = { buffer = bufnr }

				opts.desc = "next hunk"
				vim.keymap.set("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, opts)

				opts.desc = "previous hunk"
				vim.keymap.set("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, opts)

				opts.desc = "stage hunk"
				vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, opts)
				vim.keymap.set("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, opts)
				opts.desc = "reset hunk"
				vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, opts)
				vim.keymap.set("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, opts)
				opts.desc = "stage buffer"
				vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, opts)
				opts.desc = "undo stage hunk"
				vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, opts)
				opts.desc = "reset buffer"
				vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, opts)
				opts.desc = "preview hunk"
				vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, opts)
				opts.desc = "blame line"
				vim.keymap.set("n", "<leader>hb", function()
					gitsigns.blame_line({ full = true })
				end, opts)
				opts.desc = "toggle line blame"
				vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, opts)
				opts.desc = "diffthis"
				vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, opts)
				opts.desc = "diffthis ~"
				vim.keymap.set("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end, opts)
				opts.desc = "gitsigns toggle deleted"
				vim.keymap.set("n", "<leader>td", gitsigns.toggle_deleted, opts)

				opts.desc = "select hunk"
				vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", opts)
			end,
		})
	end,
}
