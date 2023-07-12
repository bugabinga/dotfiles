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
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = 'Telescope',
    event = 'VeryLazy',
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
            horizontal = { prompt_position = 'top', preview_width = 0.69 },
            vertical = { mirror = false },
            width = 0.88,
            height = 0.69,
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
          extensions = {
						file_browser = {
							theme = 'ivy',
							-- cwd_to_path = true,
							-- select_buffer = true,
							-- collapse_dirs = true,
							git_status = false,
							-- auto_depth = true,
							-- grouped = true,
						},
          },
        },
      }

      require'neoclip'.setup{}

      local extensions = {
        'fzf',
        'noice',
        'file_browser',
        'neoclip',
      }

      for _, extension in pairs(extensions) do
        if not pcall(telescope.load_extension, extension) then
          vim.notify('Telescope extension ' .. extension .. ' could not be loaded!', 'error')
        end
      end

      map.normal {
				name = 'Open file explorer...',
				category = 'telescope',
				keys = '<C-b>',
				command = function()
					telescope.extensions.file_browser.file_browser()
				end,
      }

      map.normal.visual.terminal {
				name = 'Search help files',
				category = 'help',
				keys = '<F1>',
				command = function() builtin.help_tags(dropdown) end,
      }

      map.normal {
				name = 'Open file explorer with current file...',
				category = 'telescope',
				keys = '<C-b><C-b>',
				command = function()
					local path =  vim.api.nvim_buf_get_name(0)
					telescope.extensions.file_browser.file_browser{ path = vim.fs.dirname(path), select_buffer = true }
				end,
      }

      map.normal {
				name = 'Open clipboard history...',
				category = 'history',
				keys = '<C-p><C-v>',
				command = function() telescope.extensions.neoclip.default(cursor) end,
      }

      map.normal {
				name = 'Open macro history...',
				category = 'history',
				keys = '<C-p><C-m>',
				command = function() telescope.extensions.macroscope.default(dropdown) end,
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

      map.normal {
				name = 'Open search for notifications...',
        category = 'search',
				keys = '<C-p><C-n>', 
        command = function() telescope.extensions.noice.noice() end,
      }

    end,
    dependencies = {
    	'nvim-telescope/telescope-file-browser.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
			'AckslD/nvim-neoclip.lua',
      'nvim-tree/nvim-web-devicons',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      },
    },
  },
}
