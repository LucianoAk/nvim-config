-- Sync Neovim with the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Add line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Map <leader> to space key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setup tabsize
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Disable line wrap
vim.opt.wrap = false

-- Set colorscheme
vim.cmd.colorscheme("catppuccin")
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })

-- Bufferline configuration
vim.opt.showtabline = 1
vim.opt.tabline = "%!v:lua.get_bufferline()"

-- For Windows, use powershell as terminal instead of cmd
-- vim.o.shell = "powershell"
