return {
	name = 'tokyonight.nvim',
	dir = vim.g.nixplugins['tokyonight.nvim'],
	lazy = false,
	priority = 1000,

	opts = {
		style = 'night',
	},

	config = function(self, opts)
		require('tokyonight').setup(opts)

		vim.cmd([[colorscheme tokyonight]])
	end,
}

