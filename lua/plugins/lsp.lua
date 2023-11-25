local M = {
	name = 'nvim-lspconfig',
	dir = vim.g.nixplugins['nvim-lspconfig'],
	event = 'VeryLazy',

	dependencies = {
		'nvim-cmp',
	},
}

local lspConfigs = {
	lua_ls = {
		cmd = { vim.g.nixtools['lua-language-server'] },
	},
	nixd = {
		cmd = { vim.g.nixtools['nixd'] }
	},
}

function M.config()
	local lsp = require('lspconfig')
	for lsName, lsConfig in pairs(lspConfigs) do
		lsConfig.capabilities = vim.g.lsp_capabilities
		lsp[lsName].setup(lsConfig)
	end
end

return M
