local auto = require 'bugabinga.std.auto'
local want = require 'bugabinga.std.want'

want {
	'nvim-treesitter.install',
	'nvim-treesitter.configs',
	'nvim-treesitter.parsers',
	'hlargs',
	'neogen',
} (function(install, configs, parsers, hlargs, neogen)
	install.compilers = { 'zig cc', 'clang', 'gcc', 'cl', 'cc', vim.fn.getenv 'CC' }
	install.prefer_git = true

  configs.setup {
    -- A list of parser names, or "all"
    ensure_installed = {
      'c',
      'bash',
      'cmake',
      'comment',
      'cpp',
      'css',
      'dockerfile',
      'dot',
      'help',
      'html',
      'http',
      'java',
      'javascript',
      'json',
      'json5',
      'jsonc',
      'llvm',
      'lua',
      'make',
      'markdown',
      'ninja',
      'proto',
      'python',
      'query',
      'regex',
      'rust',
      'toml',
      'vim',
      'yaml',
      'zig',
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,
		-- Automatically install missing parsers when entering buffer
		auto_install = true,
    -- List of parsers to ignore installing (for "all")
    ignore_install = {},
		highlight = {
			-- `false` will disable the whole extension
			enable = true,
			disable = {},

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = 'gnn',
				node_incremental = 'grn',
				scope_incremental = 'grc',
				node_decremental = 'grm',
			},
		},
		-- indent on = with TS
		indent = {
			enable = true,
		},
		-- These features are mostly useful when there is treesitter parser, but no
		-- LSP.
		-- FIXME: harmonize the keybinds with LSP equivalents
		refactor = 'all',
		textsubjects = {
			enable = true,
			prev_selection = '<Down>', -- (Optional) keymap to select the previous selection
			keymaps = {
				['<Up>'] = 'textsubjects-smart',
				['<Right>'] = 'textsubjects-container-outer',
				['<Left>'] = 'textsubjects-container-inner',
			},
		},
		textobjects = {
			select = {
				enable = true,
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				},
			},
			swap = {
				enable = true,
				swap_next = {
					['<leader>a'] = '@parameter.inner',
				},
				swap_previous = {
					['<leader>A'] = '@parameter.inner',
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					[']m'] = '@function.outer',
					[']]'] = '@class.outer',
				},
				goto_next_end = {
					[']M'] = '@function.outer',
					[']['] = '@class.outer',
				},
				goto_previous_start = {
					['[m'] = '@function.outer',
					['[['] = '@class.outer',
				},
				goto_previous_end = {
					['[M'] = '@function.outer',
					['[]'] = '@class.outer',
				},
			},
			lsp_interop = {
				enable = true,
				border = 'rounded',
				peek_definition_code = {
					['<leader>df'] = '@function.outer',
					['<leader>dc'] = '@class.outer',
				},
			},
		},
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = 'o',
				toggle_hl_groups = 'i',
				toggle_injected_languages = 't',
				toggle_anonymous_nodes = 'a',
				toggle_language_display = 'I',
				focus_language = 'f',
				unfocus_language = 'F',
				update = 'R',
				goto_node = '<cr>',
				show_help = '?',
			},
		},
		context_commentstring = {
			enable = true,
		},
		-- autoclose and rename tags
		autotag = {
			enable = true,
		},
	}

	parsers.get_parser_configs().just = {
		install_info = {
			url = 'https://github.com/IndianBoy42/tree-sitter-just', -- local path or git repo
			files = { 'src/parser.c', 'src/scanner.cc' },
			branch = 'main',
		},
		maintainers = { '@IndianBoy42' },
	}

	-- highlight function arguments
	-- TODO: define color
	hlargs.setup()

	-- generate doc comment annotations
	-- TODO: setup keybind
	neogen.setup{
		snippet_engine = 'luasnip',
	}

	map {
		description = 'Generate Doc Comment for Function',
		category = map.CATEGORY.EDITING,
		mode = map.MODE.NORMAL,
		keys = map.KEY.LEADER .. map.KEY.N .. map.KEY.F,
		command = function() neogen.generate{ type = 'func'} end,
	}

	-- FIXME: this aucmd needs to be restricted to buffers where treesitter is loaded
	-- Treesitter highlights tend to highlight syntax errors immediately.
	-- But that i find distracting while typing.
	-- Disable the error highlight while typing, but keep it in normal mode.
	auto 'disable_error_highlight_while_typing' {
		{
			description = 'Disable the @error highlight while in Insert mode',
			events = 'InsertEnter',
			pattern = '*',
			command = function()
				want { 'nvim-treesitter.highlight' } (function(highlight)
					pcall(highlight.stop)
					pcall(highlight.set_custom_captures, { error = 'None' })
					pcall(highlight.start)
				end)
			end,
		},
		{
			description = 'Enable the @error highlight while in Normal mode',
			events = 'InsertLeave',
			pattern = '*',
			command = function()
				want { 'nvim-treesitter.highlight' } (function(highlight)
					pcall(highlight.stop)
					pcall(highlight.set_custom_captures, { error = 'TSError' })
					pcall(highlight.start)
				end)
			end,
		},
	}
end)
