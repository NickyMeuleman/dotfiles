-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

require("nicky.options")
vim.g.have_nerd_font = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("nicky.keymaps")
require("nicky.autocmds")