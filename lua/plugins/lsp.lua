local lspConfigs = {
	lua_ls = {
		cmd = { vim.g.nixtools['lua-language-server'] },
	},
}

return {
	name = 'nvim-lspconfig',
	dir = vim.g.nixplugins['nvim-lspconfig'],
	event = 'VeryLazy',

	dependencies = {
		'nvim-cmp',
	},

	config = function()
		local lsp = require('lspconfig')
		for lsName, lsConfig in ipairs(lspConfigs) do
			lsConfig.capabilities = vim.g.lsp_capabilities

			lsp[lsName].setup(lsConfig)
		end
	end,
}
