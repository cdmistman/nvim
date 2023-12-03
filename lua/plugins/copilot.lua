local nixpkgs = require('nixpkgs')

return {
	'copilot.lua',
	event = 'InsertEnter',

	opts = {
		copilot_node_command = nixpkgs['nodejs_20'] .. '/bin/node',
		panel = { enabled = false },
		suggestion = { enabled = false },
	},
}

