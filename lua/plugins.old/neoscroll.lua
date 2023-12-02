return {
	name = 'neoscroll.nvim',
	dir = vim.g.nixplugins['neoscroll.nvim'],
	event = 'VeryLazy',

	opts = {
		mappings = { 'zt', 'zz', 'zb' },
		pre_hook = function() vim.print('zzzcrolling') end,
	},
}

