vim.opt.relativenumber = true -- show line numbers relative to the current line in the gutter
vim.opt.number = true         -- show absolute number of current line in the gutter

vim.opt.tabstop = 2           -- number of columns that a <Tab> counts for
vim.opt.shiftwidth = 2        -- number of spaces used for a step of (auto)indenting. Used by <<, >>
vim.opt.expandtab = true      -- use spaces instead of a tab when a <Tab> is inserted and indenting with < and >

vim.opt.breakindent = true    -- keep indentation of wrapped lines
vim.opt.scrolloff = 8         -- minimal number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8     -- minimal number of columns to keep to the left and right of the cursor

vim.opt.ignorecase = true     -- ignore case in search patterns
vim.opt.smartcase = true      -- if you include mixed case in your search, assumes you want case-sensitive

vim.opt.signcolumn = "yes"    -- always show the gutter to the left of line numbers (for git status, errors, warnings)
vim.opt.cursorline = true     -- highlight the current line

vim.opt.splitbelow = true     -- force all horizontal splits to go below current window
vim.opt.splitright = true     -- force all vertical splits to go to the right of current window

vim.opt.updatetime = 500      -- faster CursorHold event trigger and swapfile write
vim.opt.timeoutlen = 800      -- time to wait for a mapped keysequence to complete (in milliseconds)
vim.opt.confirm = true        -- confirm before closing a buffer with unsaved changes
vim.opt.undofile = true       -- persistent undo

vim.opt.mouse = "a"           -- allow mouse
