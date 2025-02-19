return {
	"mrcjkb/rustaceanvim",
	version = "^4", -- Recommended
	ft = { "rust" },
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"WhoIsSethDaniel/mason-tool-installer.nvim", -- install rust-analyzer LSP
		"rcarriga/nvim-dap-ui", -- install debug adapter
		"nvim-treesitter/nvim-treesitter", -- install treesitter parser for Rust
		"stevearc/dressing.nvim", -- ui plugin used as fallback for non-grouped code-actions
	},
	config = function()
		-- Do not call the nvim-lspconfig.rust_analyzer setup or set up the lsp client for rust-analyzer manually, as doing so may cause conflicts.
		-- This is a filetype plugin that works out of the box, so there is no need to call a setup function or configure anything to get this plugin working
		-- You will most likely want to add some keymaps. Most keymaps are only useful in rust files, so I suggest you define them in ~/.config/nvim/after/ftplugin/rust.lua
		-- If you want to share keymaps with nvim-lspconfig, you can also use the vim.g.rustaceanvim.server.on_attach function, or an LspAttach autocommand.
		-- Do not set vim.g.rustaceanvim in after/ftplugin/rust.lua, as the file is sourced after the plugin is initialized.
		vim.g.rustaceanvim = {
			-- plugin configuration
			tools = {
				code_actions = {
					-- If you set the option vim.g.rustaceanvim.tools.code_actions.ui_select_fallback to true (defaults to false),
					-- it will fall back to vim.ui.select if there are no grouped code actions.
					ui_select_fallback = true,
				},
			},
			-- LSP configuration
			server = {
				on_attach = function(client, bufnr)
					-- This plugin gets loaded after lspconfig, for conflicting keymaps the ones in this function will win
					-- not using grouped codeactions because they error with:
					-- Error executing vim.schedule lua callback: ...vim/lazy/dressing.nvim/lua/dressing/select/telescope.lua:29: attempt to index field 'ctx' (a nil value)
					-- https://github.com/stevearc/dressing.nvim/issues/128
					-- vim.keymap.set("n", "<leader>ca", function()
					-- 	vim.cmd.RustLsp("codeAction")
					-- end, { buffer = bufnr, desc = "Code actions (Rust)" })

					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end,
				default_settings = {
					-- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
					-- https://rust-analyzer.github.io/manual.html#configuration
					["rust-analyzer"] = {
						completion = {
							snippets = {
								custom = {
									-- for Snippet-Scopes: expr, item (default: item)
									-- for Postfix-Snippet-Scopes: expr, type (default: expr)
									["Arc"] = {
										postfix = "arc",
										body = "Arc::new(${receiver})",
										requires = "std::sync::Arc",
										description = "Put the expression into an `Arc`",
										scope = "expr",
									},
									["Rc"] = {
										postfix = "rc",
										body = "Rc::new(${receiver})",
										requires = "std::rc::Rc",
										description = "Put the expression into an `Rc`",
										scope = "expr",
									},
									["Box::pin"] = {
										postfix = "pinbox",
										body = "Box::pin(${receiver})",
										requires = "std::boxed::Box",
										description = "Put the expression into a pinned `Box`",
										scope = "expr",
									},
									["Result"] = {
										postfix = { "result", "res" },
										body = "Result<${receiver}>",
										description = "Wrap the expression in a `Result`",
										scope = "expr",
									},
									["Ok"] = {
										postfix = "ok",
										body = "Ok(${receiver})",
										description = "Wrap the expression in a `Result::Ok`",
										scope = "expr",
									},
									["Err"] = {
										postfix = "err",
										body = "Err(${receiver})",
										description = "Wrap the expression in a `Result::Err`",
										scope = "expr",
									},
									["Option"] = {
										postfix = "opt",
										body = "Option<${receiver}>",
										description = "Wrap the expression in a `Option`",
										scope = "expr",
									},
									["Some"] = {
										postfix = "some",
										body = "Some(${receiver})",
										description = "Wrap the expression in a `Option:Some`",
										scope = "expr",
									},
									["print"] = {
										postfix = { "print", "pr" },
										body = "print!(${receiver})",
										description = "Wrap the expression in a `print!()`",
										scope = "expr",
									},
									["print reference"] = {
										postfix = { "printr", "prr" },
										body = "print!(&${receiver})",
										description = "Wrap reference to the expression in a `print!()`",
										scope = "expr",
									},
									["print line"] = {
										postfix = { "println", "prl" },
										body = "println!(${receiver})",
										description = "Wrap the expression in a `println!()`",
										scope = "expr",
									},
									["print line reference"] = {
										postfix = { "printlnr", "prlr" },
										body = "println!(&${receiver})",
										description = "Wrap reference to the expression in a `println!()`",
										scope = "expr",
									},
									["debug"] = {
										postfix = "dbg",
										body = "dbg!(${receiver})",
										description = "Wrap the expression in a `dbg!()`",
										scope = "expr",
									},
									["debug reference"] = {
										postfix = "dbgr",
										body = "dbg!(&${receiver})",
										description = "Wrap reference to the expression in a `dbg!()`",
										scope = "expr",
									},
								},
							},
						},
						procMacro = {
							-- Don't expand some problematic proc_macros
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
								["async-std"] = { "async_std" },
							},
						},
						check = {
							-- Cargo command to use for cargo check.
							command = "clippy",
							-- List of features to activate. Defaults to rust-analyzer.cargo.features.
							-- Set to "all" to pass --all-features to Cargo.
							features = "all",
							-- Run Clippy only on the given crate, without linting the dependencies
							extraArgs = { "--no-deps" },
						},
						cargo = {
							-- Set this to "all" to pass --all-features to cargo.
							features = "all",
						},
						diagnostics = {
							-- Whether to run additional style lints.
							styleLints = {
								enable = true,
							},
							-- more diagnostics with more false positives but they also show in insert mode not only after saving
							experimental = {
								enable = true,
							},
						},
					},
				},
			},
		}
	end,
}
