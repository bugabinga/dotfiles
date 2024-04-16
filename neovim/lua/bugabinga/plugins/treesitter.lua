require 'bugabinga.health'.add_dependency
{ name = 'CMake', name_of_executable = 'cmake', }
	{ name_of_executable = 'make', }
	{ name_of_executable = 'zig', }
	{ name = 'TreeSitter CLI', name_of_executable = 'tree-sitter', }
	{ name_of_executable = 'tar', }

return {
	'nvim-treesitter/nvim-treesitter',
	-- version = '0.9.*',
	branch = 'master',
	-- restoring session throws errors, if this is lazy
	lazy = false,
	build = function ()
		require 'nvim-treesitter.install'.update { with_sync = true, }
	end,
	dependencies = {
		'nvim-treesitter/playground',
		'nvim-treesitter/nvim-treesitter-textobjects',
		'windwp/nvim-ts-autotag',
		'RRethy/nvim-treesitter-endwise',
		'nushell/tree-sitter-nu',
	},
	config = function ()
		local install = require 'nvim-treesitter.install'
		local configs = require 'nvim-treesitter.configs'

		install.prefer_git = false
		install.compilers = { 'clang', 'zig', 'gcc', 'cl', 'cc', vim.fn.getenv 'CC', }


		local should_disable = function ( _, bufnr )
			local max_filesize = 5 * 1024 * 1024 --MiB
			local ok, stats = pcall( vim.loop.fs_stat, vim.api.nvim_buf_get_name( bufnr or 0 ) )
			if ok and stats and stats.size > max_filesize then
				return true
			end
			return false
		end

		---@diagnostic disable-next-line: missing-fields
		configs.setup {
			sync_install = false,
			ensure_installed = {
				'bash',
				'c',
				'comment',
				'diff',
				'dot',
				'dtd',
				'git_config',
				'gitattributes',
				'gitcommit',
				'gitignore',
				'ini',
				'java',
				'just',
				'jsonc',
				'lua',
				'luap',
				'luadoc',
				'markdown',
				'markdown_inline',
				'muttrc',
				'nasm',
				'nix',
				'nu',
				'passwd',
				'pem',
				'properties',
				'proto',
				'printf',
				'query',
				'regex',
				'ssh_config',
				'toml',
				'udev',
				'vim',
				'vimdoc',
				'xml',
				'zig',
			},

			ignore_install = { 'oil', },

			auto_install = true,

			autotag = { enable = true, disable = should_disable, },
			ewndwise = { enable = true, disable = should_disable, },

			highlight = {
				enable = true,
				disable = should_disable,
				additional_vim_regex_highlighting = false,
			},

			incremental_selection = {
				enable = true,
				disable = should_disable,
				keymaps = {
					init_selection = '<up>',
					node_incremental = '<up>',
					node_decremental = '<down>',
					scope_incremental = '<right>',
				},
			},

			indent = { enable = true, },

			playground = {
				enable = true,
				disable = should_disable,
				updatetime = 25,
				persist_queries = false,
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

			textobjects = {
				select = {
					enable = true,
					disable = should_disable,
					lookahead = true,
					keymaps = {
						['af'] = { query = '@call.outer', desc = 'outer function call', },
						['if'] = { query = '@call.inner', desc = 'inner function call', },

						['am'] = { query = '@function.outer', desc = 'outer function definition', },
						['im'] = { query = '@function.inner', desc = 'inner function definition', },

						['aa'] = { query = '@assignment.outer', desc = 'outer assignment', },
						['ia'] = { query = '@assignment.inner', desc = 'inner assignment', },

						-- l overwrites builtin. i have no good idea for better binding. use ia instead.
						-- ['la'] = { query = '@assignment.lhs', desc = 'left hand side of assignment'},
						-- ['ra'] = { query = '@assignment.rhs', desc = 'right hand side of assignment'},

						['ac'] = { query = '@class.outer', desc = 'outer class', },
						['ic'] = { query = '@class.inner', desc = 'inner class', },

						['ao'] = { query = '@conditional.outer', desc = 'outer conditional', },
						['io'] = { query = '@conditional.inner', desc = 'inner conditional', },

						['al'] = { query = '@loop.outer', desc = 'outer loop', },
						['il'] = { query = '@loop.inner', desc = 'inner loop', },

						-- this overwrites the built-in 'paragraph' object
						['ap'] = { query = '@parameter.outer', desc = 'outer parameter', },
						['ip'] = { query = '@parameter.inner', desc = 'inner parameter', },

						['at'] = { query = '@comment.outer', desc = 'outer comment', },

						['as'] = { query = '@scope', query_group = 'locals', desc = 'language scope', },
					},
					selection_modes = {
						['@parameter.outer'] = 'v',
						['@function.outer'] = 'v',
						['@class.outer'] = '<c-v>',
						['@scope'] = 'V',
					},
					include_surroundig_whitespace = true,
				},

				swap = {
					enable = true,
					disable = should_disable,
					swap_next = {
						['<leader>rwn'] = { query = '@parameter.inner', desc = 'Swap parameter with next', },
					},
					swap_previous = {
						['<leader>rwp'] = { query = '@parameter.inner', desc = 'Swap parameter with previous', },
					},
				},

				lsp_interop = {
					enable = true,
					disable = should_disable,
					border = vim.g.border_style,
					floating_preview_opts = {},
					peek_definition_code = {
						['<leader>lpf'] = { query = '@function.outer', desc = 'Peek definition of outer function.', },
						['<leader>lpc'] = { query = '@class.outer', desc = 'Peek definition of outer class.', },
					},
				},

				move = {
					enable = true,
					disable = should_disable,
					set_jumps = true,
					goto_next = {
						[']f'] = { query = '@call.outer', desc = 'Goto next function call', },
						[']m'] = { query = '@fucntion.outer', desc = 'Goto next function definition', },
						[']c'] = { query = '@class.outer', desc = 'Goto next class', },
						[']o'] = { query = '@conditional.outer', desc = 'Goto next conditional', },
						[']p'] = { query = '@parameter.outer', desc = 'Goto next parameter', },
					},
					goto_previous = {
						['[f'] = { query = '@call.outer', desc = 'Goto previous function call', },
						['[m'] = { query = '@function.outer', desc = 'Goto previous function definition', },
						['[c'] = { query = '@class.outer', desc = 'goto previous class', },
						['[o'] = { query = '@conditional.outer', desc = 'Goto previous conditional', },
						['[p'] = { query = '@parameter.outer', desc = 'Goto previous parameter', },
					},
				},
			},
		}
	end,
}
