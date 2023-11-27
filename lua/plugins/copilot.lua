return {
	name = 'copilot.lua',
	dir = vim.g.nixplugins['copilot.lua'],
	config = true,

	opts = {
		copilot_node_command = vim.g.nixpkgs['nodejs_20'] .. '/bin/node',
		panel = { enabled = false },
		suggestion = { enabled = false },
	},
}

