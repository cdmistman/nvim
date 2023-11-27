return {
	name = 'neo-tree.nvim',
	dir = vim.g.nixplugins['neo-tree.nvim'],
	config = true,
	event = 'VeryLazy',

	dependencies = {
		'nui.nvim',
		'nvim-web-devicons',
		'plenary.nvim',
	},

	opts = {
		window = {
			position = 'float',
		},
	},
}
