--- yoinked: https://github.com/LazyVim/LazyVim/commit/9d999fa210065a9903634f1e1a2053627d529dec#diff-38561569aeb10164fbfecfe70e51ffcf441d56d868fe2ca15a7c75b87dad6f03R222
---@param pkg string
---@param path? string
function get_pkg_path(pkg, path)
	local Snacks = require("snacks")
	path = path or ""
	local ret = vim.env.MASON .. "/packages/" .. pkg .. "/" .. path
	if not vim.loop.fs_stat(ret) then
		Snacks.notify("warn", ("Mason package path not found for **%s**:\n- `%s`"):format(pkg, path))
	end
	return ret
end

return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	keys = {
		{ "<Leader>bt", ":DapToggleBreakpoint<CR>", desc = "[t]oggle breakpoint" },
		{ "<Leader>bc", ":DapContinue<CR>", desc = "[c]ontinue debugging" },
		{ "<Leader>bx", ":DapTerminate<CR>", desc = "[x] terminate debugging" },
		{ "<Leader>bo", ":DapStepOver<CR>", desc = "step [o]ver debug point" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

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

		dapui.setup()

		-- joinked from https://github.com/LazyVim/LazyVim/blob/f086bcde253c29be9a2b9c90b413a516f5d5a3b2/lua/lazyvim/plugins/extras/lang/typescript.lua#L72
		-- added deno for TS files
		-- video for an expanded setup for both front and backend: https://www.youtube.com/watch?v=Ul_WPhS2bis
		if not dap.adapters["pwa-node"] then
			require("dap").adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					-- 💀 Make sure to update this path to point to your installation
					args = {
						get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
						"${port}",
					},
				},
			}
		end
		for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
			if not dap.configurations[language] then
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file (pwa-node)",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Current File (pwa-node with deno)",
						cwd = vim.fn.getcwd(),
						runtimeArgs = { "run", "--inspect-brk", "--allow-all", "${file}" },
						runtimeExecutable = "deno",
						attachSimplePort = 9229,
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to running process",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end
		end
	end,
}
