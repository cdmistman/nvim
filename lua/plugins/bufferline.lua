return {
	name = 'bufferline.nvim',
	dir = vim.g.nixplugins['bufferline.nvim'],
	main = 'bufferline',
	event = 'VeryLazy',

	opts = {
		options = {
			diagnostics = 'nvim_lsp',
		},
	}
}
