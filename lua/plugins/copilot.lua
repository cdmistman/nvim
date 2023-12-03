return {
	'copilot.lua',
	main = 'copilot',
	event = 'InsertEnter',

	opts = {
		copilot_node_command = vim.g.nixpkgs['nodejs_20'] .. '/bin/node',
		panel = { enabled = false },
		suggestion = { enabled = false },
	},
}

