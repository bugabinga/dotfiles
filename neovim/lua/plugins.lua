-- This module installs a plugin manager `packer`, that provides a
-- convenient API over the nvim package feature.
-- After installation, `packer` is configured to load all my favorite nvim plugins.
-- The module plugins extends packer via a metatable that delegates all calls from plugin to packer.
-- This way we can pretend that plugins do all the work and fine tune packer configuration.
--
-- autocommand:function    => API to create vim autocmds
-- data_path:string        => root directory into which packer can be installed, if not already done
-- non_interactive:boolean => wether to show a display when updating plugins or not. Typically set to true, when nvim is used for scripting.
return function(data_path, non_interactive)
	local plugin_package = 'plugins'
	local packer_bootstrap = false
	-- packer will be loaded into the optionals folder and loaded later on demand by `packadd packer.nvim`
	-- glob will normalize the path with respect to path separators.
	-- mixing those seems to sometimes trip up packer, though the reason is unknown.
	local packer_installation_path = data_path .. '/site/pack/' .. plugin_package .. '/opt/packer.nvim'
	if vim.fn.empty(vim.fn.glob(packer_installation_path)) > 0 then
		packer_bootstrap = vim.fn.system {
			'git',
			'clone',
			'--depth',
			'1',
			'https://github.com/wbthomason/packer.nvim',
			packer_installation_path,
		}
	end
	local packer = nil
	local init = function()
		-- lazy init the loading and configuration of packer
		if packer == nil then
			packer = require 'packer'
			packer.init {
				-- Do not create vim commands, because we will create our own, that delegate to the plugins module
				disable_commands = true,
				plugin_package = plugin_package,
				display = {
					non_interactive = non_interactive,
				},
				profile = {
					enable = true,
					threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
				},
			}
		end
		local use = packer.use
		-- reset packer in case we are reloading the whole configuration
		packer.reset()

		-- Packer can manage itself
		use { 'wbthomason/packer.nvim', opt = true }

		-- Display popup with possible keybindings to a command
		use {
			'folke/which-key.nvim',
			config = function()
				local key_labels = { ['<SPACE>'] = 'SPACE', ['<CR>'] = 'ENTER', ['<TAB>'] = 'TAB', ['.'] = 'DOT' }
				for f_key_number = 1, 12 do
					key_labels['<F' .. f_key_number .. '>'] = 'F' .. f_key_number
				end

				require('which-key').setup {
					marks = true,
					registers = true,
					spelling = { enabled = true, suggestions = 5 },
					key_labels = key_labels,
					window = { border = 'single' },
				}
			end,
		}

		-- Pretty abstraction over quicklist, loclist, messages and lsp diagnostics
		use {
			'folke/trouble.nvim',
			cmd = { 'Trouble', 'TroubleClose', 'TroubleRefresh', 'TroubleToggle' },
			requires = {
				{ 'kyazdani42/nvim-web-devicons', opt = true },
				-- patches in some highlighting groups for LSP diagnostics
				-- FIXME should just be done by my theme instead of this plugin...
				{ 'folke/lsp-colors.nvim' },
			},
			config = function()
				require('trouble').setup()
				require('lsp-colors').setup {
					Error = '#f05faf',
					Warning = '#c0af68',
					Information = '#2db8cf',
					Hint = '#19bc90',
				}
			end,
		}

		-- NVIM API for defining color schemes
		use {
			'tjdevries/colorbuddy.vim',
			config = function()
				require 'theme'(require('colorbuddy').setup())
			end,
		}

		-- Advanced parsers for better syntax highlighting
		use {
			'nvim-treesitter/nvim-treesitter',
			requires = {
				'nvim-treesitter/nvim-treesitter-refactor',
				-- Treesitter syntax highlighting for justfiles
				'IndianBoy42/tree-sitter-just',
			},
			config = function()
				require('nvim-treesitter.parsers').get_parser_configs().just = {
					install_info = {
						url = 'https://github.com/IndianBoy42/tree-sitter-just',
						files = { 'src/parser.c', 'src/scanner.cc' },
						branch = 'main',
					},
					maintainers = { '@IndianBoy42' },
				}
				require('nvim-treesitter.install').compilers = { 'clang' }
				require('nvim-treesitter.configs').setup {
					ensure_installed = {
						'zig',
						'java',
						'rust',
						'lua',
						'toml',
						'yaml',
						'json',
						'jsonc',
						'c',
						'comment',
						'html',
						'css',
						'javascript',
						'query',
						'vim',
						'just',
					},
					highlight = { enable = true },
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = '<C-Up>',
							node_incremental = '<C-Up>',
							node_decremental = '<C-Down>',
							scope_incremental = '<A-Up>',
						},
					},
					indent = { enable = true },
					query_linter = { enable = true, use_virtual_text = true, lint_events = { 'BufWrite' } },
					refactor = {
						highlight_definitions = { enable = true },
						smart_rename = { enable = true, keymaps = { smart_rename = '<LEADER>fr' } },
						navigation = {
							enable = true,
							keymaps = { goto_next_usage = '<a-.>', goto_previous_usage = '<a-,>' },
						},
					},
				}
			end,
		}

		-- Treesitter Playground
		-- Show the treesitter parse tree.
		-- Lint syntax errors
		-- Show highlight groupsunder cursor
		use {
			'nvim-treesitter/playground',
			config = function()
				local keys = require 'which-key'
				keys.register {
					['<space>.'] = {
						'<CMD>TSHighlightCapturesUnderCursor<CR>',
						'Shows the highlight group under the cursor, when TreeSitter is used.',
					},
				}
			end,
		}

		-- Basic integration of ziglang
		use { 'ziglang/zig.vim', opt = true, ft = 'zig' }

		-- Move around the buffer with easy motions
		use 'phaazon/hop.nvim'

		-- Show the actual color of color codes and names
		-- #f00    => red
		-- #00ff00 => green
		-- Blue    => blue
		--
		use {
			'norcalli/nvim-colorizer.lua',
			config = function()
				require('colorizer').setup()
			end,
		}

		-- Type :<number> to jump to line numbers
		use {
			'nacro90/numb.nvim',
			config = function()
				require('numb').setup {
					show_numbers = false,
					show_cursorline = true,
				}
			end,
		}

		-- plot srartuptime data from nvim
		use{'dstein64/vim-startuptime'}

		-- Preprepared collection of glue code for neovim lsp-client and thrid party lsp servers.
		use {
			'neovim/nvim-lspconfig',
			config = function()
				require 'lsp'()
			end,
			requires = {
				-- extensions to the std lib
				'nvim-lua/plenary.nvim',
				-- popup windows
				'nvim-lua/popup.nvim',
				-- Fuzzy matcher
				'nvim-telescope/telescope.nvim',
				-- debugging adapter -- like LSP but for debuggers
				'mfussenegger/nvim-dap',
				-- advanced rust integration
				'simrat39/rust-tools.nvim',
				-- Completions support, that integrates advanced nvim features (LSP+treesitter)
				'dcampos/nvim-snippy',
				'dcampos/cmp-snippy',
				-- autocomplete framework with LSP support
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-calc',
				'hrsh7th/cmp-emoji',
				'hrsh7th/cmp-path',
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-cmdline',
				'hrsh7th/nvim-cmp',
				-- Icons for completion UI
				'onsails/lspkind-nvim',
				-- dependency of nvim-lsputils
				'RishabhRD/popfix',
				-- collection of better handlers for lsp actions.
				-- e.g. puts selection of code actions into floating window
				'RishabhRD/nvim-lsputils',
				-- Show outline view based on LSP
				'simrat39/symbols-outline.nvim',
			},
		}

		-- comment and uncomment lines
		use { 'b3nj5m1n/kommentary' }

		-- smooth scrolling
		-- Its possible Neovide will support smooth scrool soon: https://github.com/neovim/neovim/issues/15075
		-- When it does, this plugin is redundant, if nvim runs in Neovide.
		use {
			'karb94/neoscroll.nvim',
			config = function()
				-- if not vim.g.neovide then
				require('neoscroll').setup {
					-- All these keys will be mapped. Pass an empty table ({}) for no mappings
					mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
					hide_cursor = true, -- Hide cursor while scrolling
					stop_eof = true, -- Stop at <EOF> when scrolling downwards
					respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
					cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
					easing_function = 'circular', -- Interpolation of scroll animation steps
				}
				-- end
			end,
		}

		-- Make using terminals in Neovim more comfortable
		use {
			'numtostr/FTerm.nvim',
			config = function()
				require('FTerm').setup { cmd = 'nu', border = 'single' }
			end,
		}

		-- automatically size splits reasonably
		use {
			'beauwilliams/focus.nvim',
			config = function()
				local focus = require 'focus'
				focus.signcolumn = false
			end,
		}
	end

	-- if packer was initially installed, issue a Sync command to automatically install plugins
	if packer_bootstrap then
		packer.sync()
	end

	-- the plugin module always delegates to packer, ensuring that at all times init configures packer correctly
	local plugins = setmetatable({}, {
		__index = function(_, key)
			init()
			return packer[key]
		end,
	})
	return plugins
end
