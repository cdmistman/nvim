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
	end

	if cfg['main'] == nil then
		cfg.main = pluginName
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

		if type(cfg['pre_setup_hook']) == 'function' then
			cfg:pre_setup_hook()
		end

		local module = require(cfg.main)
		if cfg['opts'] ~= nil or cfg['config'] == true then
			module.setup(cfg.opts or {})
		end

		if type(cfg['post_setup_hook']) == 'function' then
			cfg:post_setup_hook(cfg)
		end
	end

	if cfg['lazy'] == false then
		setupPlugin()
		return
	end

	vim.api.nvim_create_autocmd({'User'}, {
		pattern = pluginName,
		once = true,
		nested = true,
		callback = setupPlugin,
	})

	if cfg['event'] ~= nil then
		vim.api.nvim_create_autocmd(cfg.event, {
			callback = function()
				vim.api.nvim_exec_autocmds('User', {
					pattern = pluginName,
				})
			end,
		})
	end
end

Util.walkmods("./lua/plugins", loadPlugin, 'plugins')

