return {
	'nvim-cmp',
	main = 'cmp',
	event = 'VeryLazy',

	dependencies = {
		{
			'cmp-nvim-lsp',
		},
		{
			'copilot-cmp',
			dependencies = { 'copilot.lua' },
			main = 'copilot_cmp',
			config = true,
		}
	},

	opts = function(_, cmp)
		return {
			mapping = {
				['<CR>'] = cmp.mapping.confirm({ select = true }),
				['<C-Space>'] = cmp.mapping.complete(),
				['<Tab>'] = cmp.mapping(function(fallback)
					-- https://github.com/zbirenbaum/copilot-cmp#tab-completion-configuration-highly-recommended
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					else
						fallback()
					end
				end),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					else
						fallback()
					end
				end),
				['\\'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.close()
					else
						fallback()
					end
				end),
			},

			snippet = {
				expand = function(args)
					vim.fn['vsnip#anonymous'](args.body)
				end,
			},

			sources = cmp.config.sources({
				{ name = 'copilot' },
				{ name = 'nvim_lsp' },
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'vsnip' },
			}, {
				{ name = 'buffer' }
			}),
		}
	end,

	post_setup_hook = function()
		vim.g.lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
	end
}

