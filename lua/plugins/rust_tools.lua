return {
	name = 'rust-tools',
	dir = vim.g.nixplugins['rust-tools.nvim'],
	event = 'VeryLazy',

	dependencies = {
		'nvim-lspconfig',
	},

	opts = {
		server = {
			cmd = { vim.g.nixpkgs['rust-analyzer'] .. '/bin/rust-analyzer' },
			standalone = false,
		},
	},
}

