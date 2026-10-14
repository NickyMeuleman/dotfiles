-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

vim.g.have_nerd_font = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- core
require("nicky.options")
require("nicky.keymaps")
require("nicky.autocmds")
-- plugins
require("nicky.pack")
-- plugin specific
require("nicky.config.snacks")
-- broad concern
require("nicky.config.ui")
require("nicky.config.files")
require("nicky.config.pickers")
require("nicky.config.smart-code")
