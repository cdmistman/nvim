return {
	name = 'aerial.nvim',
	dir = vim.g.nixplugins['aerial.nvim'],
	event = 'VeryLazy',

	dependencies = {
		'nvim-web-devicons',
		'nvim-lspconfig',
		'rust-tools',
	},

	config = true,
	opts = {
		float = {
			relative = 'win',
		},
		layout = {
			default_direction = 'float'
		},
	},
}

