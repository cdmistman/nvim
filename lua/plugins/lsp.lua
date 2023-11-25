local M = {
	name = 'nvim-lspconfig',
	dir = vim.g.nixplugins['nvim-lspconfig'],
	event = 'VeryLazy',

	dependencies = {
		'nvim-cmp',
	},
}


function M.config()
	local lspConfigs = {
		lua_ls = {
			cmd = { vim.g.nixtools['lua-language-server'] },
		},
		nixd = {
			cmd = { vim.g.nixtools['nixd'] }
		},
	}

	local lsp = require('lspconfig')
	-- local lspConfigs = M.lspConfigs
	-- vim.print(vim.g.nixtools['nixd'])
	vim.print('initing ' .. #lspConfigs .. ' lsp servers')
	-- vim.print(vim.base64.encode(vim.inspect(M)))
	for lsName, lsConfig in ipairs(lspConfigs) do
		lsConfig.capabilities = vim.g.lsp_capabilities
		vim.print('initing ' .. lsName .. ' with ' .. #lsConfig .. ' opts')

		lsp[lsName].setup(lsConfig)
	end
end

return M
