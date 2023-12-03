return {
	'tokyonight.nvim',
	main = 'tokyonight',
	lazy = false,

	opts = {
		style = 'night',
	},

	post_setup_hook = function()
		vim.cmd([[colorscheme tokyonight]])
	end
}
