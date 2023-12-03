local nixpkgs = require('nixpkgs')

local M = {
	'nvim-lspconfig',
	main = 'lspconfig',
	event = 'VeryLazy',

	dependencies = {
		'nvim-cmp',

		{
			'rust-tools.nvim',
			event = 'VeryLazy',
			opts = {
				server = {
					cmd = { nixpkgs['rust-analyzer'] .. '/bin/rust-analyzer' },
					standalone = false,
				},
			},
		},
	},
}

function M:config(opts, main)
	local lsp = require(main)

	for lsName, lsConfig in pairs(opts) do
		lsConfig.capabilities = vim.g.lsp_capabilities or nil
		lsp[lsName].setup(lsConfig)
	end
end

M.opts = {
	-- let `clangd` be used from the env since i think it's tied to the actual toolchain?
	clangd = {},

	cssls = {
		cmd = { nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-css-language-server', '--stdio' },
	},

	eslint = {
		cmd = { nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-eslint-language-server', '--stdio' },
	},

	gopls = {
		cmd = { nixpkgs['gopls'] .. '/bin/gopls' },
	},

	graphql = {
		cmd = { nixpkgs['graphql-language-service-cli'] .. '/bin/graphql-lsp' },
	},

	hls = {
		cmd = { nixpkgs['haskell-language-server'] .. '/bin/haskell-language-server-wrapper', '--lsp' },
	},

	html = {
		cmd = { nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-html-language-server', '--stdio' },
	},

	jsonls = {
		cmd = { nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-json-language-server', '--stdio' },
	},

	-- TODO: for some reason lua-language-server doesn't work in this repo :(
	-- lua_ls = {
	-- 	cmd = { nixpkgs['lua-language-server'] },
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
	-- 	cmd = { nixpkgs['vscode-langservers-extracted'] .. '/bin/vscode-markdown-language-server', '--stdio' },
	-- },

	marksman = {
		cmd = { nixpkgs['marksman'] .. '/bin/marksman', 'server' },
	},

	nixd = {
		cmd = { nixpkgs['nixd'] .. '/bin/nixd' },
	},

	nushell = {
		cmd = { nixpkgs['nushell'] .. '/bin/nu', '--lsp' },
	},

	svelte = {
		cmd = { nixpkgs['svelte-language-server'] .. '/bin/svelteserver', '--stdio' },
	},

	tailwindcss = {
		cmd = { nixpkgs['tailwindcss-language-server'] .. '/bin/tailwindcss-language-server', '--stdio' },
	},

	taplo = {
		cmd = { nixpkgs['taplo'] .. '/bin/taplo', 'lsp', 'stdio' },
	},

	tsserver = {
		cmd = { nixpkgs['typescript-language-server'] .. '/bin/typescript-language-server', '--stdio' },
	},
}

return M

