-- This function configures all the LSP clients that i might care about.
-- It is expected to be called in the 'config' step of the 'lspconfig' plugin.
-- autocommand: function, that can create autocmds
return function()
	-- enable lsp-powered auto-completion
	local cmp = require 'cmp'
	local types = require 'cmp.types'
	cmp.setup {
		snippet = {
			expand = function(arguments)
				require('snippy').expand_snippet(arguments.body)
			end,
		},
		completion = {
			autocomplete = false,
		},
		confirmation = { default_behaviour = types.cmp.ConfirmBehavior.Insert },
		mapping = {
			['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
			['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-n>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
			['<C-y>'] = cmp.config.disable,
			['<C-e>'] = cmp.mapping {
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			},
			['<CR>'] = cmp.mapping.confirm { select = true },
		},
		formatting = {
			format = function(_, vim_item)
				-- adds icons into the completion ui
				vim_item.kind = require('lspkind').presets.default[vim_item.kind]
				return vim_item
			end,
		},
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'snippy' },
			{ name = 'nvim_lua' }, -- FIXME: this source only makes sense in neovim lua files...
			{ name = 'buffer' },
			{ name = 'path' },
			{ name = 'emoji' },
			{ name = 'calc' },
		},
	}

	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' },
		},
	})

	cmp.setup.cmdline(':', {
		sources = cmp.config.sources {
			{ { name = 'path' } },
			{ { name = 'cmdline' } },
		},
	})

	local keybinds_in_lsp_context = {
		g = {
			name = 'Goto Navigation',
			['D'] = { [[<CMD>lua vim.lsp.buf.declaration()<CR>]], 'Goto Declaration' },
			['d'] = { [[<CMD>lua vim.lsp.buf.definition()<CR>]], 'Goto Definition' },
			['i'] = { [[<CMD>lua vim.lsp.buf.implementation()<CR>]], 'Goto Implementation' },
			['t'] = { [[<CMD>lua vim.lsp.buf.type_definition()<CR>]], 'Goto Type Definition' },
			['w'] = { [[<CMD>lua vim.lsp.buf.document_symbol()<CR>]], 'Goto Document Symbol' },
			['W'] = { [[<CMD>lua vim.lsp.buf.workspace_symbol()<CR>]], 'Goto Workspace Symbol' },
			['n'] = { [[<CMD>lua vim.lsp.diagnostic.goto_next()<CR>]], 'Goto Next Diagnostic' },
			['N'] = { [[<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>]], 'Goto Previous Diagnostic' },
		},
		a = {
			name = 'Code Operations',
			['h'] = { [[<CMD>lua vim.lsp.buf.hover()<CR>]], 'Show Hover' },
			['d'] = {
				[[<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]],
				'Show Diagnostics on Current Line',
			},
			['s'] = { [[<CMD>lua vim.lsp.buf.signature_help()<CR>]], 'Show Signature Help' },
			['f'] = { [[<CMD>lua vim.lsp.buf.code_action()<CR>]], 'Code Actions...' },
			['r'] = { [[<CMD>lua vim.lsp.buf.rename()<CR>]], 'Rename' },
			['='] = { [[<CMD>lua vim.lsp.buf.formatting()<CR>]], 'Format' },

			['R'] = { [[<CMD>lua vim.lsp.buf.references()<CR>]], 'Show References' },
			['i'] = { [[<CMD>lua vim.lsp.buf.incoming_calls()<CR>]], 'Show Incoming Calls' },
			['o'] = { [[<CMD>lua vim.lsp.buf.outgoing_calls()<CR>]], 'Show Outgoind Calls' },
		},
	}

	local integrate_into_neovim = function(client, buffer_number)
		print('LSP ' .. client.name .. ' [' .. client.id .. '] ' .. 'started.')

		-- Configure diagnostics to only show up when not typing
		vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			signs = true,
			underline = false,
			virtual_text = false,
			update_in_insert = false,
			severity_sort = true,
		})
		local keys = require 'which-key'
		keys.register(keybinds_in_lsp_context, {
			prefix = '<LEADER>',
			buffer = buffer_number,
		})
	end

	local lsp = require 'lspconfig'

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

	-- Nvim lua configuration LSP
	local neovim_runtime_path = vim.split(package.path, ';')
	table.insert(neovim_runtime_path, 'lua/?.lua')
	table.insert(neovim_runtime_path, 'lua/?/init.lua')

	local neovim_lua_library = {}
	for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
		local lua_path = path .. '/lua/'
		if vim.fn.isdirectory(lua_path) then
			neovim_lua_library[lua_path] = true
		end
	end

	local system_name
	if vim.fn.has 'mac' == 1 then
		system_name = 'macOS'
	elseif vim.fn.has 'unix' == 1 then
		system_name = 'Linux'
	elseif vim.fn.has 'win32' == 1 then
		system_name = 'Windows'
	else
		print 'Unsupported system for sumneko'
	end
	local sumneko_home = '~/Workspace/lua-language-server'
	if system_name == 'Windows' then
		sumneko_home = 'W:/misc/lua-language-server'
	end
	-- This loads the `lua` files from nvim into the runtime.
	neovim_lua_library[vim.fn.expand '$VIMRUNTIME/lua'] = true
	--TODO: How to switch this configuration based upon if we are editing neovim configuration or just any Lua file/project?
	lsp.sumneko_lua.setup {
		on_attach = integrate_into_neovim,
		capabilites = capabilities,
		cmd = {
			sumneko_home .. '/bin/' .. system_name .. '/lua-language-server',
			'-E',
			'-W',
			sumneko_home .. '/main.lua',
		},
		settings = {
			Lua = {
				runtime = {
					version = 'LuaJIT',
					path = neovim_runtime_path,
				},
				diagnostics = {
					enable = true,
					disable = 'trailing-space',
					globals = { 'vim', '_G', 'Dump' },
				},
				hint = {
					enable = true,
				},
				workspace = {
					library = neovim_lua_library,
					maxPreload = 10000,
					preloadFileSize = 10000,
				},
				telemetry = {
					enable = true,
				},
			},
		},
	}

	-- Markdown Notes (Zettelkasten) LSP
	lsp.zeta_note.setup {
		on_attach = integrate_into_neovim,
		capabilites = capabilities,
		cmd = { 'zeta-note' },
	}

	-- YAML LSP
	lsp.yamlls.setup {
		on_attach = integrate_into_neovim,
		capabilites = capabilities,
		--FIXME: Only works on Windows
		cmd = { 'yaml-language-server.cmd', '--stdio' },
		root_dir = function()
			return vim.fn.getcwd()
		end,
	}

	-- Zig LSP
	-- FIXME: ZLS is very tied to the specific version of the zig compiler one uses.
	-- we need to build our own version for 0.8.0 because it is not done upstream yet
	lsp.zls.setup {
		on_attach = integrate_into_neovim,
		capabilites = capabilities,
	}

	-- LLVM Clang LSP
	lsp.clangd.setup {
		on_attach = integrate_into_neovim,
		capabilites = capabilities,
	}

	-- Rust LSP
	-- this will automatically start and configure nvim-lsp rust-analyzer
	require('rust-tools').setup { server = {
		on_attach = integrate_into_neovim,
		capabilities = capabilities,
	} }

	-- JSON LSP
	lsp.jsonls.setup {
		on_attach = integrate_into_neovim,
		capabilites = capabilities,
		--FIXME: Only works on Windows
		cmd = { 'vscode-json-language-server.cmd', '--stdio' },
		commands = {
			Format = {
				-- Apply the ranged formatting to the whole file
				function()
					vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line '$', 0 })
				end,
			},
		},
	}

	-- GraphViz Dot LSP
	lsp.dotls.setup {
		on_attach = integrate_into_neovim,
		capabilites = capabilities,
	}

	-- overwrite default action handlers with cuter ones
	vim.lsp.handlers['textDocument/codeAction'] = require('lsputil.codeAction').code_action_handler
	vim.lsp.handlers['textDocument/references'] = require('lsputil.locations').references_handler
	vim.lsp.handlers['textDocument/definition'] = require('lsputil.locations').definition_handler
	vim.lsp.handlers['textDocument/declaration'] = require('lsputil.locations').declaration_handler
	vim.lsp.handlers['textDocument/typeDefinition'] = require('lsputil.locations').typeDefinition_handler
	vim.lsp.handlers['textDocument/implementation'] = require('lsputil.locations').implementation_handler
	vim.lsp.handlers['textDocument/documentSymbol'] = require('lsputil.symbols').document_handler
	vim.lsp.handlers['workspace/symbol'] = require('lsputil.symbols').workspace_handler
end
