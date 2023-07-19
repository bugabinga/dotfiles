local map = require 'std.keymap'
local auto = require 'std.auto'
local want = require 'std.want'

require'bugabinga.health'.add_dependency
{
	name = 'CMake',
	name_of_executable = 'cmake'
}
{
	name_of_executable = 'make'
}
{
	name_of_executable = 'zig'
}
{
	name = 'TreeSitter CLI',
	name_of_executable = 'tree-sitter'
}
{
	name_of_executable = 'tar'
}

return {
	'nvim-treesitter/nvim-treesitter',
	branch = "master",
	event = "BufRead",
	cmd = {
		"TSBufDisable",
		"TSBufEnable",
		"TSBufToggle",
		"TSDisable",
		"TSEnable",
		"TSToggle",
		"TSInstall",
		"TSInstallInfo",
		"TSInstallSync",
		"TSModuleInfo",
		"TSUninstall",
		"TSUpdate",
		"TSUpdateSync",
		'TSPlaygroundToggle',
		'TSHighlightCapturesUnderCursor',
		'TSNodeUnderCursor',
	},
	build = function()
		require'nvim-treesitter.install'.update{ with_sync = true }
	end,
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		"windwp/nvim-ts-autotag",
		'nvim-treesitter/playground',
		'ThePrimeagen/refactoring.nvim',
	},
	config = function()
		local install = require'nvim-treesitter.install'
		local configs = require'nvim-treesitter.configs'
		local parsers = require'nvim-treesitter.parsers'

		install.prefer_git = false
		install.compilers = { 'zig', 'clang', 'gcc', 'cl', 'cc', vim.fn.getenv 'CC' }

		configs.setup {

			ensure_installed = {
				'bash',
				"c",
				'comment',
				'diff',
				'dot',
				'git_config',
				'gitcommit',
				'gitignore',
				'java',
				'jsonc',
				'markdown',
				'markdown_inline',
				"lua",
				'luap',
				'luadoc',
				'regex',
				"vim",
				"vimdoc",
				"query",
				'zig',
			},

			auto_install = true,

			autotag = { enable = true },

			-- TODO configure this
			refactor = 'all',

			context_commentstring = { enable = true, enable_autocmd = false },

			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 1000 * 1024 -- 1000 KiB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = false,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<up>",
					node_incremental = "<right>",
					node_decremental = "<left>",
					scope_incremental = false,
				},
			},

			indent = { enable = true },

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
		}

		parsers.get_parser_configs().just = {
			install_info = {
				url = 'https://github.com/IndianBoy42/tree-sitter-just', -- local path or git repo
				files = { 'src/parser.c', 'src/scanner.cc' },
				branch = 'main',
			},
			maintainers = { '@IndianBoy42' },
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

				end,
			},
			{
				description = 'Enable the @error highlight while in Normal mode',
				events = 'InsertLeave',
				pattern = '*',
				command = function()

				end,
			},
		}
	end,
}
