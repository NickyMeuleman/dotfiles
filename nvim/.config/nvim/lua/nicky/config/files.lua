local MiniFiles = require("mini.files")

MiniFiles.setup({
  windows = { preview = true },
  mappings = { go_in_plus = '<CR>' }
})

vim.keymap.set("n", "<leader>e", function()
  if MiniFiles.close() then return end
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or not vim.uv.fs_stat(path) then
    path = vim.fn.getcwd()
  end
  MiniFiles.open(path, false)
  MiniFiles.reveal_cwd()
end, { desc = "Toggle file explorer at current location" })

require("oil").setup({
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-r>"] = "actions.refresh",
    ["q"] = "actions.close",
  },
  view_options = { show_hidden = true },
  win_options = { signcolumn = "yes:2" },
})

require("oil-git-status").setup({ show_ignored = false })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
