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

function addPlugin(cfg)
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

		local module = nil
		if cfg['opts'] ~= nil or cfg['config'] == true then
			module = require(cfg.main)
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

	if cfg['event'] == nil then
		return
	end

	local events = cfg.event
	if type(events) == 'string' then
		events = { events }
	elseif type(events) ~= 'table' then
		log.err('option \'events\' should be a table or a string')
		return
	end

	local is_very_lazy = false
	local shift = 0

	for ii, ev in ipairs(events) do
		if type(ev) == 'table' then
			addPlugin(ev)
			ev = ev[1]
		end

		if ev == 'VeryLazy' then
			is_very_lazy = true
			shift = shift + 1
		end

		events[ii - shift] = ev
		events[ii] = nil
	end

	if is_very_lazy then
		vim.api.nvim_create_autocmd('User', {
			pattern = 'VeryLazy',
			once = true,
			callback = function()
				vim.api.nvim_exec_autocmds('User', {
					pattern = pluginName,
				})
			end,
		})
	end

	if #events > 0 then
		vim.api.nvim_create_autocmd(events, {
			once = true,
			callback = function()
				vim.api.nvim_exec_autocmds('User', {
					pattern = pluginName,
				})
			end,
		})
	end
end

Util.walkmods(
	"./lua/plugins",
	function(modname, modpath)
		log.info('loading config ' .. modname .. ' at ' .. modpath)
		addPlugin(require(modname))
	end, 'plugins')

vim.schedule(
  function()
		vim.api.nvim_exec_autocmds('User', {
			pattern = 'VeryLazy',
		})
	end
)

