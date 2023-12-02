return {
	name = "persistence.nvim",
	dir = vim.g.nixplugins["persistence.nvim"],
	event = 'BufReadPre',
	config = true,
}

