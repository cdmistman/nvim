local M = {
	'which-key.nvim',
	lazy = false,

	opts = {},
}

function M:pre_setup_hook()
	vim.o.timeout = true
	vim.o.timeoutlen = 300
end

function M:post_setup_hook(wk)
	wk.register({
		f = { name = 'find' },
		g = { name = 'go to' },
		p = { name = 'project' },
		v = { name = 'version control' },
	}, {
		prefix = '<leader>',
	})

	wk.register({
		name = 'buffer',
		n = { '<cmd>bn<cr>', 'next' },
		p = { '<cmd>bp<cr>', 'previous' },
	}, {
		prefix = '<leader>b',
	})

	wk.register({
		name = 'window',
		h = { '<cmd>wincmd h<cr>', 'left' },
		j = { '<cmd>wincmd j<cr>', 'down' },
		k = { '<cmd>wincmd k<cr>', 'up' },
		l = { '<cmd>wincmd l<cr>', 'right' },
		s = { '<cmd>split<cr>', 'split' },
		S = { '<cmd>vsplit<cr>', 'vsplit' },
	}, {
		prefix = '<leader>w',
	})
end

return M

