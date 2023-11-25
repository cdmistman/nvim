vim.g.editorconfig = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

vim.opt.rtp:prepend(vim.g.nixplugins['lazy.nvim'])
require('lazy').setup('plugins', {
	change_detection = {
		enabled = false,
	},
	defaults = {
		lazy = true,
	},
	diff = {
		cmd = 'terminal_git',
	},
	install = {
		missing = false,
	},
	performace = {
		rtp = {
			reset = false
		},
	},
})
