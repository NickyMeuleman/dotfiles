return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = function()
		local harpoon = require("harpoon")
		local key_specs = {
			{
				"<leader>ha",
				function()
					harpoon:list():add()
				end,
				desc = "harpoon [a]dd to list",
			},
			{
				"<leader>ht",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "harpoon [t]oggle list",
			},
			-- Toggle previous & next buffers stored within Harpoon list
			{
				"<C-S-p>",
				function()
					harpoon:list():prev()
				end,
				desc = "go to [p]revious in harpoon list",
			},
			{
				"<C-S-n>",
				function()
					harpoon:list():next()
				end,
				desc = "go to [n]ext in harpoon list",
			},
		}

		for pos = 1, 9 do
			table.insert(key_specs, {
				"<leader>h" .. pos,
				function()
					harpoon:list():select(pos)
				end,
				desc = "go to [h]arpoon pos #" .. pos,
			})
		end

		return key_specs
	end,
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
	end,
}
