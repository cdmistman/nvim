return {
	name = 'neo-tree.nvim',
	dir = vim.g.nixplugins['neo-tree.nvim'],
	config = true,
	lazy = false,

	dependencies = {
		'nui.nvim',
		'nvim-web-devicons',
		'plenary.nvim',
	},
}
