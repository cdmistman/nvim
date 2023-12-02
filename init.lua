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
	plugins[pluginName] = cfg

	local loadThisPlugin = function(ev)
		if ev ~= nil then
			vim.print('loading plugin ' .. pluginName .. ' for event ' .. ev.event .. ' : ' .. vim.inspect(ev))
		else
			vim.print('loading plugin ' .. pluginName)
		end

		if cfg['dependencies'] ~= nil then
			vim.api.nvim_exec_autocmds('User', {
				pattern = cfg['dependencies'],
			})
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
		once = true,
		nested = true,
		callback = loadThisPlugin,
	})

	if cfg['events'] ~= nil then
		vim.api.nvim_create_autocmd(cfg.events, {
			callback = function()
				vim.api.nvim_exec_autocmds('User', {
					pattern = pluginName,
				})
			end
		})
	end
end

Util.walkmods("./lua/plugins", loadPlugin, 'plugins')

