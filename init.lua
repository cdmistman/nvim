vim.g.editorconfig = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

require('lazy').setup('plugins', {
	defaults = {
		lazy = true,
	},
	diff = {
		cmd = 'terminal_git',
	},
	change_detection = {
		enabled = false,
	},
})
