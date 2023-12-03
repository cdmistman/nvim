vim.g.editorconfig = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

local log = require('log')
local Util = require('lazy.core.util')

local plugins = {}

function loadPlugin(modname, modpath)
	log.info('loading plugin ' .. modname .. ' at ' .. modpath)

	local cfg = require(modname)

	local pluginName = cfg[1]
	if pluginName == nil then
		log.err('not loading, option [1] not specified.')
		return
	elseif cfg['main'] == nil then
		log.err('not loading, option \'main\' not specified.')
	end

	plugins[pluginName] = cfg

	local setupPlugin = function(ev)
		if ev ~= nil then
			log.info('setting up plugin ' .. pluginName .. ' for event ' .. ev.event .. ' : ' .. vim.inspect(ev))
		else
			log.info('setting up plugin ' .. pluginName)
		end

		if cfg['dependencies'] ~= nil then
			vim.api.nvim_exec_autocmds('User', {
				pattern = cfg['dependencies'],
			})
		end

		if cfg['pre_setup_hook'] ~= nil and type(cfg['pre_setup_hook']) == 'function' then
			cfg['pre_setup_hook'](cfg)
		end

		local module = require(cfg.main)
		if cfg['opts'] ~= nil or cfg['config'] == true then
			module.setup(cfg.opts or {})
		end

		if cfg['post_setup_hook'] ~= nil and type(cfg['post_setup_hook']) == 'function' then
			cfg['post_setup_hook'](cfg)
		end
	end

	vim.api.nvim_create_autocmd({'User'}, {
		pattern = pluginName,
		once = true,
		nested = true,
		callback = setupPlugin,
	})

	local runSetupPlugin = function()
		vim.api.nvim_exec_autocmds('User', {
			pattern = pluginName,
		})
	end

	if cfg['lazy'] == false then
		runSetupPlugin()
	elseif cfg['event'] ~= nil then
		vim.api.nvim_create_autocmd(cfg.event, {
			callback = runSetupPlugin,
		})
	end
end

Util.walkmods("./lua/plugins", loadPlugin, 'plugins')

