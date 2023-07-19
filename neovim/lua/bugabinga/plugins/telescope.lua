local map = require 'std.keymap'

require'bugabinga.health'.add_dependency
{
	name = 'ripgrep',
	name_of_executable = 'rg'
}
{
	name = 'find-fd',
	name_of_executable = 'fd'
}

return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	cmd = 'Telescope',
	keys = { '<C-p><C-n>', '<C-e>', '<C-p><C-b>',  '<C-p><C-g>', '<C-p><C-s>', '<C-p><C-k>', '<C-p><C-p>', '<C-p>', '<F1>' },
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
		'nvim-telescope/telescope-symbols.nvim',
	},
	config = function()
		local telescope = require 'telescope'
		local builtin = require 'telescope.builtin'
		local actions = require 'telescope.actions'
		local themes = require 'telescope.themes'
		local ivy = themes.get_ivy { layout_config = { preview_width = 0.69 } }
		local dropdown = themes.get_dropdown { layout_config = { width = 0.69 } }
		local cursor = themes.get_cursor { layout_config = { preview_width = 0.42, width = 0.69 } }

		telescope.setup {
			defaults = {
				path_display = { 'truncate' },
				sorting_strategy = 'ascending',
				layout_config = {
					horizontal = { prompt_position = 'bottom', preview_width = 0.69 },
					vertical = { mirror = false },
					width = 0.69,
					height = 0.42,
					preview_cutoff = 124,
				},
				mappings = {
					i = {
						['<C-j>'] = actions.cycle_history_next,
						['<C-k>'] = actions.cycle_history_prev,
						['<C-n>'] = actions.move_selection_next,
						['<C-p>'] = actions.move_selection_previous,
					},
					n = { q = actions.close },
				},
			},
		}

		map.normal.visual.terminal {
			name = 'Search help files',
			category = 'help',
			keys = '<F1>',
			command = function() builtin.help_tags(dropdown) end,
		}

		map.normal {
			name = 'Open global search...',
			category = 'plugins',
			keys = '<C-p>',
			command = function() builtin.builtin() end,
		}

		map.normal {
			name = 'Open search for all files...',
			category = 'search',
			keys = '<C-p><C-p>',
			command = function() builtin.find_files(ivy) end,
		}

		map.normal {
			name = 'Open search for keymaps...',
			category = 'search',
			keys = '<C-p><C-k>',
			command = function() builtin.keymaps(dropdown) end,
		}

		map.normal {
			name = 'Open search for symbols...',
			category = 'search',
			keys = '<C-p><C-s>',
			command = function() builtin.symbols(cursor) end,
		}

		map.normal {
			name = 'Open search for all file contents...',
			category = 'search',
			keys = '<C-p><C-g>',
			command = function() builtin.live_grep(ivy) end,
		}

		map.normal {
			name = 'Open search for current buffer content...',
			category = 'search',
			keys = '<C-p><C-b>',
			command = function() builtin.current_buffer_fuzzy_find(ivy) end,
		}

		map.normal {
			name = 'Open search for buffers...',
			category = 'search',
			keys = '<C-e>',
			command = function() builtin.buffers(cursor) end,
		}

	end,
}