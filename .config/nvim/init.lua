vim.opt.relativenumber = true -- show line numbers relative to the current line in the gutter 
vim.opt.number = true -- show absolute number of current line in the gutter
vim.opt.cursorline = true -- highlight the current line

vim.opt.tabstop = 2 -- number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 2 -- number of spaces used for a step of (auto)indenting. Used by <<, >>
vim.opt.expandtab = true -- use spaces instead of a tab when a <Tab> is inserted and indenting with < and >

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {}
local opts = {}

require("lazy").setup(plugins, opts)
