local M = {
	name = 'nvim-cmp',
	dir = vim.g.nixplugins['nvim-cmp'],
	event = 'VeryLazy',
	main = 'cmp',

	dependencies = {
		'vim-vsnip',

		{
			name = 'copilot-cmp',
			dir = vim.g.nixplugins['copilot-cmp'],
			dependencies = { 'copilot.lua' },
			main = 'copilot_cmp',
			config = true,
		},
		{
			name = 'cmp-buffer',
			dir = vim.g.nixplugins['cmp-buffer'],
			main = 'cmp_buffer',
		},
		{
			name = 'cmp-nvim-lsp',
			dir = vim.g.nixplugins['cmp-nvim-lsp'],
			config = true,
		},
		{
			name = 'cmp-nvim-lsp-document-symbol',
			dir = vim.g.nixplugins['cmp-nvim-lsp-document-symbol'],
		},
		{
			name = 'cmp-nvim-lsp-signature-help',
			dir = vim.g.nixplugins['cmp-nvim-lsp-signature-help'],
		},
		{
			name = 'cmp-vsnip',
			dir = vim.g.nixplugins['cmp-vsnip'],
		},
	},

	keys = {
		{ '<CR>', mode = 'i' },
		{ '<C-Space>', mode = 'i' },
		{ '<Tab>', mode = 'i' },
		{ '<S-Tab>', mode = 'i' },
		{ '<Esc>', mode = 'i' },
	},
}

-- function has_words_before()
	-- if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		-- return false
	-- end
  -- local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
-- end

function M.config(p)
	local cmp = require('cmp')

	cmp.setup({
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
	})

	vim.g.lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
end

return M
