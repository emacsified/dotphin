vim.opt.guicursor = ""  -- Disable cursorline

vim.opt.nu = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers

vim.opt.tabstop = 4 -- Tab size
vim.opt.softtabstop = 4 -- Tab size
vim.opt.shiftwidth = 4 -- Tab size
vim.opt.expandtab = true -- Use spaces instead of tabs

vim.opt.smartindent = true -- Auto indent

vim.opt.wrap = false -- Wrap lines

vim.opt.swapfile = false -- Disable swap files
vim.opt.backup = false -- Disable backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Undo directory
vim.opt.undofile = true -- Enable undo files

vim.opt.hlsearch = false -- Disable search highlighting
vim.opt.incsearch = true -- Incremental search

vim.opt.termguicolors = true -- True color support

vim.opt.scrolloff = 8 -- Scroll offset
vim.opt.signcolumn = "yes" -- Show sign column
vim.opt.isfname:append("@-@") -- Allow @ in file names

vim.opt.updatetime = 50 -- Update time

vim.opt.colorcolumn = "80" -- Color column

