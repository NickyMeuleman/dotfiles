require("nicky.options")
-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = " " -- character that replaces the special <leader> mapping in keybinds
require("nicky.keymaps")
require("nicky.lazy")
