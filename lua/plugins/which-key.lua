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
		f = { name = '+file' },
		p = { name = '+project' },
	}, {
		prefix = '<leader>',
	})

	wk.register({
		name = '+buffer',
		n = { '<cmd>bn<cr>', 'next' },
		p = { '<cmd>bp<cr>', 'previous' },
		d = { '<cmd>bd<cr>', 'delete' },
	}, {
		prefix = '<leader>b',
	})

	wk.register({
		name = '+help',
		d = { '<cmd>helpc<cr>', 'close' },
	}, {
		prefix = '<leader>h',
	})

	wk.register({
		name = '+window',
		h = { '<cmd>wincmd h<cr>', 'left' },
		j = { '<cmd>wincmd j<cr>', 'down' },
		k = { '<cmd>wincmd k<cr>', 'up' },
		l = { '<cmd>wincmd l<cr>', 'right' },
		s = { '<cmd>split<cr>', 'split' },
		S = { '<cmd>vsplit<cr>', 'vsplit' },
		d = { '<cmd>close<cr>', 'close' },
	}, {
		prefix = '<leader>w',
	})
end

return M

