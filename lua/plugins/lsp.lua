local M = {
	name = 'nvim-lspconfig',
	dir = vim.g.nixplugins['nvim-lspconfig'],
	event = 'VeryLazy',

	dependencies = {
		'direnv.vim',
		'nvim-cmp',
	},
}

local lspConfigs = {
	-- let `clangd` be used from the env since i think it's tied to the actual toolchain?
	clangd = {},

	cssls = {
		cmd = { vim.g.nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-css-language-server', '--stdio' },
	},

	eslint = {
		cmd = { vim.g.nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-eslint-language-server', '--stdio' },
	},

	gopls = {
		cmd = { vim.g.nixpkgs['gopls'] .. '/bin/gopls' }
	},

	graphql = {
		cmd = { vim.g.nixpkgs['graphql-language-service-cli'] .. '/bin/graphql-lsp' }
	},

	hls = {
		cmd = { vim.g.nixpkgs['haskell-language-server'] .. '/bin/haskell-language-server-wrapper', '--lsp' }
	},

	html = {
		cmd = { vim.g.nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-html-language-server', '--stdio' },
	},

	jsonls = {
		cmd = { vim.g.nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-json-language-server', '--stdio' },
	},

	-- TODO: for some reason lua-language-server doesn't work in this repo :(
	-- lua_ls = {
	-- 	cmd = { vim.g.nixpkgs['lua-language-server'] },
	-- 	root_dir = {},
	-- 	on_init = function(client)
	-- 		local path = client.workspace_folders[1].name
	-- 		if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
	-- 			return true
	-- 		end
	-- 		client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
	-- 			Lua = {
	-- 				runtime = {
	-- 					version = 'LuaJIT',
	-- 				},
	-- 				workspace = {
	-- 					checkThirdParty = false,
	-- 					library = vim.api.nvim_get_runtime_file('', true),
	-- 				},
	-- 			}
	-- 		})
	-- 		client.notify('workspace/didChangeConfiguration', {
	-- 			settings = client.config.settings,
	-- 		})
	-- 		return true
	-- 	end,
	-- },

	-- TODO: markdown lsp using vscode's lsp server
	-- markdown = {
	-- 	cmd = { vim.g.nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-markdown-language-server', '--stdio' },
	-- },

	marksman = {
		cmd = { vim.g.nixpkgs['marksman'] .. '/bin/marksman', 'server' }
	},

	nixd = {
		cmd = { vim.g.nixpkgs['nixd'] .. '/bin/nixd' }
	},

	nushell = {
		cmd = { vim.g.nixpkgs['nushell'] .. '/bin/nu', '--lsp' }
	},

	svelte = {
		cmd = { vim.g.nixpkgs['svelte-language-server'] .. '/bin/svelteserver', '--stdio' },
	},

	tailwindcss = {
		cmd = { vim.g.nixpkgs['tailwindcss-language-server'] .. '/bin/tailwindcss-language-server', '--stdio' },
	},

	taplo = {
		cmd = { vim.g.nixpkgs['taplo'] .. '/bin/taplo', 'lsp', 'stdio' }
	},

	tsserver = {
		cmd = { vim.g.nixpkgs['typescript-language-server'] .. '/bin/typescript-language-server', '--stdio' },
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
