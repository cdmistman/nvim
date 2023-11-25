return {
	name = 'bufferline.nvim',
	dir = vim.g.nixplugins['bufferline.nvim'],
	lazy = false,

	config = function()
		require('bufferline').setup({})
	end,

	-- opts = {
	-- 	diagnostics = 'nvim_lsp',
	-- },
}
