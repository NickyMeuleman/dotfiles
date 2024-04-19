return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<leader>ht", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<C-e>", function()
			harpoon:list():select(2)
		end)
    -- problem for the jumplist, C-o and C-i are jump out and jump in
		-- vim.keymap.set("n", "<C-i>", function()
		-- 	harpoon:list():select(3)
		-- end)
		-- vim.keymap.set("n", "<C-o>", function()
		-- 	harpoon:list():select(4)
		-- end)

		vim.keymap.set("n", "<leader><C-n>", function()
			harpoon:list():replace_at(1)
		end)
		vim.keymap.set("n", "<leader><C-e>", function()
			harpoon:list():replace_at(2)
		end)
		vim.keymap.set("n", "<leader><C-i>", function()
			harpoon:list():replace_at(3)
		end)
		vim.keymap.set("n", "<leader><C-o>", function()
			harpoon:list():replace_at(4)
		end)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end)

		for pos = 1, 9 do
			vim.keymap.set("n", "<leader>h" .. pos, function()
				harpoon:list():select(pos)
			end, { desc = "Move to harpoon mark #" .. pos })
		end
	end,
}
