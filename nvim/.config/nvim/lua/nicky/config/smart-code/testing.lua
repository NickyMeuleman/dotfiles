local neotest = require("neotest")

---@diagnostic disable-next-line: missing-fields
neotest.setup({
	adapters = {
		require("rustaceanvim.neotest"),
	},
})

vim.keymap.set("n", "<leader>tt", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run File Tests" })

vim.keymap.set("n", "<leader>tT", function()
	neotest.run.run(vim.uv.cwd())
end, { desc = "Run All Test Files" })

vim.keymap.set("n", "<leader>tr", function()
	neotest.run.run()
end, { desc = "Run Nearest Test" })

vim.keymap.set("n", "<leader>tl", function()
	neotest.run.run_last()
end, { desc = "Run Last Test" })

vim.keymap.set("n", "<leader>ts", function()
	neotest.summary.toggle()
end, { desc = "Toggle Test Summary" })

vim.keymap.set("n", "<leader>to", function()
	neotest.output.open({
		enter = true,
		auto_close = true,
	})
end, { desc = "Show Test Output" })

vim.keymap.set("n", "<leader>tO", function()
	neotest.output_panel.toggle()
end, { desc = "Toggle Output Panel" })

vim.keymap.set("n", "<leader>tS", function()
	neotest.run.stop()
end, { desc = "Stop Tests" })
