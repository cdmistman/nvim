local M = {
	name = 'nvim-cmp',
	dir = vim.g.nixplugins['nvim-cmp'],
	event = 'VeryLazy',
	main = 'cmp',

	dependencies = {
		'vim-vsnip',

		{
			name = 'cmp-nvim-lsp',
			dir = vim.g.nixplugins['cmp-nvim-lsp'],
		},
		{
			name = 'cmp-vsnip',
			dir = vim.g.nixplugins['cmp-vsnip'],
		}
	},
}

function M.config(p)
	local cmp = require('cmp')

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn['vsnip#anonymous'](args.body)
			end,
		},

		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
		}, {
			{ name = 'buffer' }
		}),
	})

	vim.g.lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
end

return M
