return {
	'neo-tree.nvim',
	event = 'VeryLazy',
	main = 'neo-tree',

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

