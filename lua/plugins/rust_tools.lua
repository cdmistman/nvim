local M = {
	name = 'rust-tools',
	dir = vim.g.nixplugins['rust-tools.nvim'],
	event = 'VeryLazy',

	dependencies = {
		'nvim-lspconfig',
	},

	config = true,
	opts = {
		server = {
			cmd = { vim.g.nixpkgs['rust-analyzer'] .. '/bin/rust-analyzer' },
			standalone = false,
		},
	},
}

return M

