local gitsigns = require("gitsigns")
gitsigns.setup({
	on_attach = function(bufnr)
		vim.keymap.set("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { desc = "Jump to next git [c]hange", buf = bufnr })

		vim.keymap.set("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { desc = "Jump to previous git [c]hange", buf = bufnr })

		vim.keymap.set("v", "<leader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "git [s]tage hunk", buf = bufnr })
		vim.keymap.set("v", "<leader>gr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "git [r]eset hunk", buf = bufnr })
		vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "git [s]tage hunk", buf = bufnr })
		vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "git [r]eset hunk", buf = bufnr })
		vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "git [S]tage buffer", buf = bufnr })
		vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "git [R]eset buffer", buf = bufnr })
		vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "git [p]review hunk", buf = bufnr })
		vim.keymap.set(
			"n",
			"<leader>gi",
			gitsigns.preview_hunk_inline,
			{ desc = "git preview hunk [i]nline", buf = bufnr }
		)
		vim.keymap.set("n", "<leader>gb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "git [b]lame line", buf = bufnr })
		vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "git [d]iff against index", buf = bufnr })
		vim.keymap.set("n", "<leader>gD", function()
			gitsigns.diffthis("~")
		end, { desc = "git [D]iff against last commit", buf = bufnr })
		vim.keymap.set("n", "<leader>gQ", function()
			gitsigns.setqflist("all")
		end, { desc = "git hunk [Q]uickfix list (all files in repo)", buf = bufnr })
		vim.keymap.set(
			"n",
			"<leader>gq",
			gitsigns.setqflist,
			{ desc = "git hunk [q]uickfix list (all changes in this file)", buf = bufnr }
		)

		require("snacks").toggle
			.new({
				name = "Git Line Blame",
				get = function()
					return require("gitsigns.config").config.current_line_blame
				end,
				set = function(state)
					gitsigns.toggle_current_line_blame(state)
				end,
			})
			:map("<leader>ub", { desc = "Toggle git show [b]lame line", buffer = bufnr })

		require("snacks").toggle
			.new({
				name = "Git Word Diff",
				get = function()
					return require("gitsigns.config").config.word_diff
				end,
				set = function(state)
					gitsigns.toggle_word_diff(state)
				end,
			})
			:map("<leader>uw", { desc = "Toggle git intra-line [w]ord diff", buffer = bufnr })

		vim.keymap.set({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "text object [i]nside [h]unk", buf = bufnr })
	end,
})

vim.keymap.set("n", "<leader>gl", function()
	require("snacks").lazygit()
end, { desc = "Open [l]azygit" })

require("neogit").setup({})

vim.keymap.set("n", "<leader>gn", "<cmd>Neogit<CR>", { desc = "Open [n]eogit" })
