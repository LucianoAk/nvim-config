-- Sync Neovim with the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Add line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Map <leader> to space key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Change explorer
vim.opt.autochdir = true
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
