local nixpkgs = require('nixpkgs')

local M = {
	'nvim-lspconfig',
	main = 'lspconfig',
	lazy = false,

	dependencies = {
		'nvim-cmp',
	},
}

function buf_load_lsp_keymap(ev)
	local wk = require('which-key')

	local function code_format()
		vim.lsp.buf.format({
			async = true,
		})
	end

	wk.register({
		g = {
			d = { vim.lsp.buf.definition, 'definition' },
			D = { vim.lsp.buf.declaration, 'declaration' },
			i = { vim.lsp.buf.implementation, 'implementation' },
			r = { vim.lsp.buf.references, 'references' },
		},
	}, {
		buffer = ev.buf,
	})

	wk.register({
		c = {
			a = { vim.lsp.buf.code_action, 'action', mode = { 'n', 'v' } },
			d = {
				name = "+diagnostic",
				n = { vim.diagnostic.goto_next, 'next' },
				N = { vim.diagnostic.goto_prev, 'previous' },
				H = { vim.diagnostic.open_float, 'show' },
			},
			f = { code_format, 'format' },
			l = { vim.lsp.codelens.refresh, 'codelens' },
			r = { vim.lsp.buf.rename, 'rename' },
		},
		g = {
			d = { vim.lsp.buf.definition, 'definition' },
			D = { vim.lsp.buf.declaration, 'declaration' },
			i = { vim.lsp.buf.implementation, 'implementation' },
			r = { vim.lsp.buf.references, 'references' },
		},
		H = { vim.lsp.buf.hover, 'hover' },
	}, {
		prefix = '<leader>',
		buffer = ev.buf,
	})
end

function M:config(opts, main)
	local lsp = require(main)

	for lsName, lsConfig in pairs(opts) do
		lsConfig.capabilities = vim.g.lsp_capabilities or nil
		lsp[lsName].setup(lsConfig)
	end

	vim.api.nvim_create_autocmd('LSPAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = buf_load_lsp_keymap,
	})
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

local pathlib = require('plenary.path')
M.opts.lua_ls = {
	cmd = { nixpkgs['lua-language-server'] .. '/bin/lua-language-server' },
	on_init = function(client)
		local path = pathlib.new(client.workspace_folders[1].name)
		if path:joinpath('.luarc.json'):exists() or path:joinpath('.luarc.jsonc'):exists() then
			return true
		end
		client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
			Lua = {
				runtime = {
					version = 'LuaJIT',
				},
				workspace = {
					checkThirdParty = false,
					library = vim.api.nvim_get_runtime_file('', true),
				},
			}
		})
		client.notify('workspace/didChangeConfiguration', {
			settings = client.config.settings,
		})
		return true
	end,
}

-- rustaceanvim doesn't use setup() args
vim.g.rustaceanvim = {
	server = {
		capabilities = vim.g.lsp_capabilities or nil,
		cmd = { nixpkgs['rust-analyzer'] .. '/bin/rust-analyzer' },
		default_settings = {
			['rust-analyzer'] = {
				cargo = {
					features = "all",
					targetDir = true,
				},
				files = {
					excludeDirs = {
						".direnv",
						"result",
					},
				},
			},
		},
	},
}

return M
