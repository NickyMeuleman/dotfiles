return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<Leader>bt", ":DapToggleBreakpoint<CR>")
		vim.keymap.set("n", "<Leader>bc", ":DapContinue<CR>")
		vim.keymap.set("n", "<Leader>bx", ":DapTerminate<CR>")
		vim.keymap.set("n", "<Leader>bo", ":DapStepOver<CR>")
	end,
}
