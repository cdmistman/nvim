local M = {
	'telescope.nvim',
	event = 'VeryLazy',

	opts = {},
}

function M:post_setup_hook()
	local builtins = require('telescope.builtin')
	local wk = require('which-key')

	wk.register(
		{
			f = { builtins.find_files, 'files' },
			g = { builtins.live_grep, 'grep' },
			b = { builtins.buffers, 'buffers' },
			h = { builtins.help_tags, 'help' },
		}, {
			prefix = '<leader>f',
		}
	)
end

return M

