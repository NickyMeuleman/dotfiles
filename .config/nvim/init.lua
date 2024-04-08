vim.opt.relativenumber = true -- show line numbers relative to the current line in the gutter 
vim.opt.number = true -- show absolute number of current line in the gutter
vim.opt.cursorline = true -- highlight the current line

vim.opt.tabstop = 2 -- number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 2 -- number of spaces used for a step of (auto)indenting. Used by <<, >>
vim.opt.expandtab = true -- use spaces instead of a tab when a <Tab> is inserted and indenting with < and >

-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = " " -- character that replaces the special <leader> mapping in keybinds

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

local plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }
}
local opts = {}

require("lazy").setup(plugins, opts)

require("catppuccin").setup({
  flavour = "frappe"
})
vim.cmd("colorscheme catppuccin")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>sb', builtin.buffers, {})
vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})

local configs = require("nvim-treesitter.configs")
configs.setup({
  -- install grammars for these languages so TS can parse them into a correct AST
  ensure_installed = {
    "bash",
    "c",
    "css",
    "dockerfile",
    "gitignore",
    "graphql",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "prisma",
    "query",
    "rust",
    "svelte",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
  -- syntax highlighting based on TS grammars
  highlight = { enable = true },
  -- indentation logic uses ths TS grammars
  indent = { enable = true },
})
