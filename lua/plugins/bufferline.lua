local M = {
	name = 'bufferline.nvim',
	dir = vim.g.nixplugins['bufferline.nvim'],
	lazy = false,

	opts = {
		options = {
			diagnostics = 'nvim_lsp',
		},
	}
}

function M.config(p, opts)
	require('bufferline').setup(opts)
end

return M
