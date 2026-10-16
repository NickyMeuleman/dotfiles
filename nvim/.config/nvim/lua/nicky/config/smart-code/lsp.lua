local servers = {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
        lua_ls = {
                on_init = function(client)
                        client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

                        if client.workspace_folders then
                                local path = client.workspace_folders[1].name
                                if
                                    path ~= vim.fn.stdpath("config")
                                    and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                                then
                                        return
                                end
                        end

                        -- https://github.com/neovim/nvim-lspconfig/issues/3189
                        local runtime_files = vim.tbl_filter(function(dir)
                                return not dir:match(vim.fn.stdpath("config") .. "/?a?f?t?e?r?")
                        end, vim.api.nvim_get_runtime_file("", true))

                        local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
                        client.config.settings.Lua = vim.tbl_deep_extend("force", current_settings.Lua, {
                                runtime = {
                                        version = "LuaJIT",
                                        path = { "lua/?.lua", "lua/?/init.lua" },
                                },
                                workspace = {
                                        checkThirdParty = false,
                                        library = runtime_files,
                                },
                        })
                end,
                ---@type lspconfig.settings.lua_ls
                settings = {
                        Lua = {
                                format = { enable = false }, -- Disable formatting (formatting is done by stylua)
                        },
                },
        },
}

for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                -- "gra" (Normal and Visual mode) is mapped to |vim.lsp.buf.code_action()|
                opts.desc = "Code actions"
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                -- "gri" is mapped to |vim.lsp.buf.implementation()|
                opts.desc = "Go to implementation"
                -- lowercase "gi" is a default map that enters insert mode where you last exited insert mode, so capital I
                vim.keymap.set("n", "gI", function() require("snacks").picker.lsp_implementations() end, opts)
                -- "grn" is mapped to |vim.lsp.buf.rename()|
                opts.desc = "Rename"
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                -- "grr" is mapped to |vim.lsp.buf.references()|
                opts.desc = "Show LSP references"
                vim.keymap.set("n", "gr", function() require("snacks").picker.lsp_references() end, opts)
                -- "grt" is mapped to |vim.lsp.buf.type_definition()|
                opts.desc = "Show LSP t[y]pe definitions"
                -- gt and gT are default tab navigation keymaps, so gy
                vim.keymap.set("n", "gy", function() require("snacks").picker.lsp_type_definitions() end, opts)
                -- "gO" is mapped to |vim.lsp.buf.document_symbol()|
                opts.desc = "Show LSP symbols"
                vim.keymap.set("n", "<leader>ss", function() require("snacks").picker.lsp_symbols() end, opts)
                opts.desc = "Show LSP workspace Symbols"
                vim.keymap.set("n", "<leader>sS", function() require("snacks").picker.lsp_workspace_symbols() end, opts)

                -- "grx" is mapped to |vim.lsp.codelens.run()|
                -- CTRL-S (Insert mode) is mapped to |vim.lsp.buf.signature_help()|
                -- |K| is mapped to |vim.lsp.buf.hover()| unless 'keywordprg' is customized or a custom keymap for `K` exists.

                -- vim.lsp.buf.definition
                opts.desc = "Go to definition"
                vim.keymap.set("n", "gd", function() require("snacks").picker.lsp_definitions() end, opts)
                -- vim.lsp.buf.declaration
                opts.desc = "Go to declaration"
                vim.keymap.set("n", "gD", function() require("snacks").picker.lsp_declarations() end, opts)
        end,
})
