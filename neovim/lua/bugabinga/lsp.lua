local icon = require 'bugabinga.std.icon'
local map = require 'bugabinga.std.keymap'
local auto = require 'bugabinga.std.auto'
local project = require 'bugabinga.std.project'
local want = require 'bugabinga.std.want'

-- TODO: setup codelens -> use lsp-signature plugin?
-- TODO: setup custom cmp keybinds
want {
	'lsp-zero',
	'null-ls',
	'nvim-lsp-installer',
	'neodev',
	'rust-tools',
	'nvim-navic',
	'lsp-status',
} (function(zero, null_ls, installer, neodev, rust, navic, lsp_status)
	installer.settings {
		ui = {
			--TODO: use some global float window settings
			border = 'rounded',
		},
	}

	zero.preset 'recommended'
	zero.set_preferences {
		configure_diagnostics = false,
		set_lsp_keymaps = false,
		sign_icons = {
			error = icon 'Error',
			warn = icon 'Warning',
			hint = icon 'Hint',
			info = icon 'Information',
		},
	}

	-- setup lsp for my neovim config
	zero.nvim_workspace {
		-- add paths of all plugins and neovim
		library = vim.api.nvim_get_runtime_file('', true),
	}
	-- Initialize rust_analyzer with rust-tools
	rust.setup {
		server = zero.build_options('rust_analyzer', {}),
	}

	-- this will prevent zero from loading this server.
	-- Java will be managed by nvim-jdtls, which wants to do things differently.
	-- see ftplugin/java.lua
	zero.build_options('jdtls', {})

	-- lua neovim lsp
	neodev.setup {
		lspconfig = zero.defaults.nvim_workspace(),
	}

	-- disable disco mode while typing
	zero.setup_nvim_cmp {
		completion = {
			autocomplete = false,
		},
	}

	local null_opts = zero.build_options 'null-ls'

	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
	local code_actions = null_ls.builtins.code_actions
	local hover = null_ls.builtins.hover
	local completion = null_ls.builtins.completion

	-- run diagnostics on save
	local diagnostics_on_save = { method = null_ls.methods.DIAGNOSTICS_ON_SAVE }
	null_ls.setup {
		on_attach = null_opts.on_attach,
		sources = {
			formatting.stylua,
			formatting.clang_format,
			formatting.jq,
			formatting.protolint,
			formatting.shellharden,
			formatting.shfmt,
			formatting.taplo,

			hover.dictionary,

			diagnostics.actionlint.with(diagnostics_on_save),
			diagnostics.checkmake.with(diagnostics_on_save),
			diagnostics.gitlint.with(diagnostics_on_save),
			diagnostics.protoc_gen_lint.with(diagnostics_on_save),
			diagnostics.protolint.with(diagnostics_on_save),
			diagnostics.selene.with(diagnostics_on_save).with {
				-- null-ls determines the root in a too simplistic manner.
				-- since my neovim configuration live inside my dotfiles, the dotfiles root
				-- was taken. but i want the neovim config folder as root.
				cwd = function(parameters)
					local root = project.determine_project_root({ name = 'selene.toml', weight = 10 }, parameters.root)
					return root or parameters.root
				end,
			},
			diagnostics.shellcheck.with(diagnostics_on_save),
			diagnostics.tidy.with(diagnostics_on_save),

			code_actions.refactoring,
			code_actions.shellcheck,

			completion.luasnip,
		},
	}

local function setup_keybinds_and_actions(client, buffer_number)
		-- TODO: make format changed lines command
		local capabilities = client.server_capabilities
		if capabilities.document_formatting then
			map {
				description = 'Format buffer using LSP',
				category = map.CATEGORY.EDITING,
				mode = map.MODE.NORMAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.F,
				command = function()
					vim.lsp.buf.format { bufnr = buffer_number }
					vim.notify('Formatted ' .. vim.api.nvim_buf_get_name(buffer_number))
				end,
			}
		end
		if capabilities.document_range_formatting then
			map {
				description = 'Format range using LSP',
				category = map.CATEGORY.EDITING,
				mode = map.MODE.VISUAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.F,
				command = function()
					vim.lsp.buf.range_formatting { bufnr = buffer_number }
					vim.notify('Formatted range in ' .. vim.api.nvim_buf_get_name(buffer_number))
				end,
			}
		end
		--TODO: change some of these commands to telescoped versions
		if capabilities.hover then
			map {
				description = 'Show Hover',
				category = map.CATEGORY.VIEW,
				mode = map.MODE.NORMAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.K,
				command = function()
					vim.lsp.buf.hover()
				end,
			}
		end
		if capabilities.goto_definition then
			map {
				description = 'Go to Definition',
				category = map.CATEGORY.NAVIGATION,
				mode = map.MODE.NORMAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.D,
				command = function()
					vim.lsp.buf.definition()
				end,
			}
		end
		if capabilities.declaration then
			map {
				description = 'Go to Declaration',
				category = map.CATEGORY.NAVIGATION,
				mode = map.MODE.NORMAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.D .. map.KEY.D,
				command = function()
					vim.lsp.buf.declaration()
				end,
			}
		end
		if capabilities.implementation then
			map {
				description = 'Go to Implementation',
				category = map.CATEGORY.NAVIGATION,
				mode = map.MODE.NORMAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.I,
				command = function()
					vim.lsp.buf.implementation()
				end,
			}
		end
		if capabilities.type_definition then
			map {
				description = 'Go to Type Definition',
				category = map.CATEGORY.NAVIGATION,
				mode = map.MODE.NORMAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.T,
				command = function()
					vim.lsp.buf.type_definition()
				end,
			}
		end
		if capabilities.find_references then
			map {
				description = 'Go to References',
				category = map.CATEGORY.NAVIGATION,
				mode = map.MODE.NORMAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.R,
				command = function()
					vim.lsp.buf.references()
				end,
			}
		end
		if capabilities.call_hierarchy then
			map {
				description = 'Go to Incoming Call',
				category = map.CATEGORY.NAVIGATION,
				mode = map.MODE.NORMAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.C,
				command = function()
					vim.lsp.buf.incoming_calls()
				end,
			}
			map {
				description = 'Go to Outgoing Call',
				category = map.CATEGORY.NAVIGATION,
				mode = map.MODE.NORMAL,
				keys = map.KEY.LEADER .. map.KEY.L .. map.KEY.C .. map.KEY.C,
				command = function()
					vim.lsp.buf.outgoing_calls()
				end,
			}
		end
		if capabilities.rename then
			map {
				description = 'Rename symbol',
				category = map.CATEGORY.EDITING,
				mode = map.MODE.NORMAL,
				keys = map.KEY.F2,
				command = function()
					vim.lsp.buf.rename()
				end,
			}
		end
		if capabilities.code_action then
			map {
				description = 'Show code actions',
				category = map.CATEGORY.VIEW,
				mode = map.MODE.NORMAL,
				keys = map.KEY.F4,
				command = function()
					vim.lsp.buf.code_action()
				end,
			}
			map {
				description = 'Show code actions in range',
				category = map.CATEGORY.VIEW,
				mode = map.MODE.VISUAL,
				keys = map.KEY.F4,
				command = function()
					vim.lsp.buf.range_code_action()
				end,
			}
		end
		if capabilities.document_highlight then
			-- this variable should technically be scoped to the current buffer.
			-- how to do that?
			local highlight_timer = nil
			auto 'highlight_reference_under_cursor' {
				{
					description = 'Automatically highlight a symbol under cursor',
					events = 'CursorHold',
					pattern = '<buffer>',
					command = function()
						if not highlight_timer then
							highlight_timer = vim.defer_fn(function()
								vim.lsp.buf.document_highlight()
								highlight_timer = nil
							end, 866)
						end
					end,
				},
				{
					description = 'Clear highlighted symbol under cursor',
					events = { 'CursorMoved', 'CursorMovedI', 'InsertEnter' },
					pattern = '<buffer>',
					command = function()
						if highlight_timer then
							highlight_timer:close()
							highlight_timer = nil
						end
						vim.lsp.buf.clear_references()
					end,
				},
			}
		end
	end

	zero.on_attach(function(client, buffer_number)
		if client.name ~= 'null-ls' and not vim.b.lsp_attached then
			navic.attach(client, buffer_number)
			lsp_status.on_attach(client, buffer_number)
			setup_keybinds_and_actions(client, buffer_number)
		end
	end)

	zero.setup()
	
end)
