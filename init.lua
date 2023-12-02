vim.g.editorconfig = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

local Util = require('lazy.core.util')

local plugins = {}

function loadPlugin(modname, modpath)
	vim.print('loading plugin ' .. modname .. ' at ' .. modpath)

	local cfg = require(modname)
	local pluginName = cfg[1]
	vim.print(vim.inspect(cfg))
	plugins[pluginName] = cfg

	local loadThisPlugin = function(ev)
		if ev ~= nil then
			vim.print('loading plugin ' .. pluginName .. ' for event ' .. ev.event .. ' : ' .. vim.inspect(ev))
		else
			vim.print('loading plugin ' .. pluginName)
		end

		if cfg['pre_load_hook'] ~= nil and type(cfg['pre_load_hook']) == 'function' then
			cfg['pre_load_hook'](cfg)
		end

		local module = require(cfg.main)
		if cfg['opts'] ~= nil or cfg['setup'] then
			module.setup(cfg.opts or {})
		end

		if cfg['post_load_hook'] ~= nil and type(cfg['post_load_hook']) == 'function' then
			cfg['post_load_hook'](cfg)
		end
	end

	vim.api.nvim_create_autocmd({'User'}, {
		pattern = pluginName,
		callback = loadThisPlugin,
	})
end

vim.print('walking')
Util.walkmods("./lua/plugins", loadPlugin, 'plugins')

-- eg /nix/store/8p5yq86nw5imk33hsp8d291zs5s38q77-brs089lk6b0p03apwvr1khzcgk2jg5s1-source/init.lua
-- vim.print(thisdir:sub(2))

-- vim.opt.rtp:prepend(vim.g.nixplugins['lazy.nvim'])
-- require('aerial').setup({
-- 	float = {
-- 		relative = 'win',
-- 	},
-- 	layout = {
-- 		default_direction = 'float'
-- 	},
-- })

-- require('lazy').setup('plugins', {
-- 	change_detection = {
-- 		enabled = false,
-- 	},
-- 	defaults = {
-- 		lazy = true,
-- 	},
-- 	diff = {
-- 		cmd = 'terminal_git',
-- 	},
-- 	install = {
-- 		missing = false,
-- 	},
-- 	performace = {
-- 		reset_packpath = false,
-- 		rtp = {
-- 			reset = false
-- 		},
-- 	},
-- })
