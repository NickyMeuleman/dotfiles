-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

vim.g.have_nerd_font = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("nicky.options")
require("nicky.keymaps")
require("nicky.autocmds")

require("nicky.pack")

require("nicky.config.ui")
require("nicky.config.files")
