return {
	name = 'telescope.nvim',
	dir = vim.g.nixplugins['telescope.nvim'],
	event = 'VeryLazy',

	dependencies = {
		'plenary.nvim',
	},

	config = true,
}

