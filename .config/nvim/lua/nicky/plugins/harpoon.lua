return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	keys = function()
		local harpoon = require("harpoon")
		local key_specs = {
			{
				"<leader>ha",
				function()
					harpoon:list():add()
				end,
			},
			{
				"<leader>ht",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
			},
			{
				"<C-n>",
				function()
					harpoon:list():select(1)
				end,
			},
			{
				"<C-e>",
				function()
					harpoon:list():select(2)
				end,
			},
			{
				"<leader><C-n>",
				function()
					harpoon:list():replace_at(1)
				end,
			},
			{
				"<leader><C-e>",
				function()
					harpoon:list():replace_at(2)
				end,
			},
			-- Toggle previous & next buffers stored within Harpoon list
			{
				"<C-S-p>",
				function()
					harpoon:list():prev()
				end,
			},
			{
				"<C-S-n>",
				function()
					harpoon:list():next()
				end,
			},
		}

		for pos = 1, 9 do
			table.insert(key_specs, {
				"<leader>h" .. pos,
				function()
					harpoon:list():select(pos)
				end,
				desc = "Move to harpoon mark #" .. pos,
			})
		end

		return key_specs
	end,
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()
	end,
}
