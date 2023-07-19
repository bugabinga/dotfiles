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
		"nvim-treesitter/nvim-treesitter-textobjects",
		"windwp/nvim-ts-autotag",
		'nvim-treesitter/playground',
	},
	config = function()
		local install = require'nvim-treesitter.install'
		local configs = require'nvim-treesitter.configs'
		local parsers = require'nvim-treesitter.parsers'

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
			-- TODO what does this do?
			incremental_selection = { enable = true },
			indent = { enable = true },
			lsp_interop = {
				enable = true,
				border = 'rounded',
				peek_definition_code = {
					['<leader>df'] = '@function.outer',
					['<leader>dc'] = '@class.outer',
				},
			},
			textsubjects = {
				enable = true,
				prev_selection = '<Down>', -- (Optional) keymap to select the previous selection
				keymaps = {
					['<Up>'] = 'textsubjects-smart',
					['<Right>'] = 'textsubjects-container-outer',
					['<Left>'] = 'textsubjects-container-inner',
				},
			},
			-- TODO how to learn those?
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["ak"] = { query = "@block.outer", desc = "around block" },
						["ik"] = { query = "@block.inner", desc = "inside block" },
						["ac"] = { query = "@class.outer", desc = "around class" },
						["ic"] = { query = "@class.inner", desc = "inside class" },
						["a?"] = { query = "@conditional.outer", desc = "around conditional" },
						["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
						["af"] = { query = "@function.outer", desc = "around function " },
						["if"] = { query = "@function.inner", desc = "inside function " },
						["al"] = { query = "@loop.outer", desc = "around loop" },
						["il"] = { query = "@loop.inner", desc = "inside loop" },
						["aa"] = { query = "@parameter.outer", desc = "around argument" },
						["ia"] = { query = "@parameter.inner", desc = "inside argument" },
					},
				},
				--TODO learn to use move and swap
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]k"] = { query = "@block.outer", desc = "Next block start" },
						["]f"] = { query = "@function.outer", desc = "Next function start" },
						["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
					},
					goto_next_end = {
						["]K"] = { query = "@block.outer", desc = "Next block end" },
						["]F"] = { query = "@function.outer", desc = "Next function end" },
						["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
					},
					goto_previous_start = {
						["[k"] = { query = "@block.outer", desc = "Previous block start" },
						["[f"] = { query = "@function.outer", desc = "Previous function start" },
						["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
					},
					goto_previous_end = {
						["[K"] = { query = "@block.outer", desc = "Previous block end" },
						["[F"] = { query = "@function.outer", desc = "Previous function end" },
						["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						[">K"] = { query = "@block.outer", desc = "Swap next block" },
						[">F"] = { query = "@function.outer", desc = "Swap next function" },
						[">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
					},
					swap_previous = {
						["<K"] = { query = "@block.outer", desc = "Swap previous block" },
						["<F"] = { query = "@function.outer", desc = "Swap previous function" },
						["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
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
