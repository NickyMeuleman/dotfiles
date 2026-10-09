vim.opt.relativenumber = true -- show line numbers relative to the current line in the gutter
vim.opt.number = true -- show absolute number of current line in the gutter

vim.opt.tabstop = 2 -- number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 2 -- number of spaces used for a step of (auto)indenting. Used by <<, >>
vim.opt.expandtab = true -- use spaces instead of a tab when a <Tab> is inserted and indenting with < and >

vim.opt.wrap = false -- turn off line wrapping
vim.opt.scrolloff = 8 -- minimal number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- minimal number of columns to keep to the left and right of the cursor

vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

vim.opt.signcolumn = "yes" -- always show the gutter to the left of line numbers (for git status, errors, warnings)
vim.opt.cursorline = true -- highlight the current line

vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window

vim.opt.updatetime = 500 -- faster CursorHold event trigger and swapfile write
-- timeout and timeoutlen set during whichkey setup

vim.opt.mouse = "a" -- allow mouse
vim.opt.showmode = false -- hide mode, statusline plugin already shows this

vim.opt.completeopt = "menu,menuone,noinsert,noselect,preview" -- autocompletion dropdown behaviour

vim.opt.shortmess:append("c") -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"

vim.opt.iskeyword:append("-") -- treats kebab-case as a single word
-- this option will often be overridde by vim default ftplugin settings, booooo
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- prevent automatic formatting of a new line when pressing o on a comment line in normal mode, enter in insert

