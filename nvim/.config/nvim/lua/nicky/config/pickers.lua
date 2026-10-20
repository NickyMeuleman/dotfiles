vim.g.fff = {
	lazy_sync = true,
	debug = { enabled = true, show_scores = true },
}

local fff = require("fff")
fff.setup({ prompt = "> " })

local snacks_picker = require("snacks").picker

vim.keymap.set("n", "<leader>sf", function()
	fff.find_files()
end, { desc = "Search [f]iles" })
vim.keymap.set("n", "<leader>st", function()
	snacks_picker.git_files()
end, { desc = "Search git file [t]ree" })
vim.keymap.set("n", "<leader>sg", function()
	fff.live_grep()
end, { desc = "Search by [g]rep" })
vim.keymap.set("n", "<leader>sl", function()
	snacks_picker.lines()
end, { desc = "Search in buffer [l]ines" })
vim.keymap.set("n", "<leader>sb", function()
	snacks_picker.buffers()
end, { desc = "Search [b]uffers" })
vim.keymap.set("n", "<leader>sh", function()
	snacks_picker.help()
end, { desc = "Search [h]elp" })
vim.keymap.set("n", "<leader>sc", function()
	snacks_picker.colorschemes()
end, { desc = "Search [c]olorschemes" })
vim.keymap.set("n", "<leader>sd", function()
	snacks_picker.diagnostics_buffer()
end, { desc = "Search buffer [d]iagnostics" })
vim.keymap.set("n", "<leader>sD", function()
	snacks_picker.diagnostics()
end, { desc = "Search workspace [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", function()
	snacks_picker.resume()
end, { desc = "Search [r]esume last picker" })

vim.keymap.set("n", "<leader>n", function()
	snacks_picker.notifications()
end, { desc = "Show [n]otifications" })
