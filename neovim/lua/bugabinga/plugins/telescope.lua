local map = require 'std.map'

require 'bugabinga.health'.add_dependency
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
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'jvgrootveld/telescope-zoxide',
  },
  config = function()
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'
    local actions = require 'telescope.actions'
    local themes = require 'telescope.themes'
    local ivy = themes.get_ivy { hidden = true, layout_config = { preview_width = 0.69 } }
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
        file_ignore_patterns = {
          ".git/",
          ".cache",
          "%.o",
          "%.a",
          "%.out",
          "%.class",
          "%.pdf",
          "%.mkv",
          "%.mp4",
          "%.zip",
        },
        mappings = {
          i = {
            ['<C-j>'] = actions.cycle_history_next,
            ['<C-k>'] = actions.cycle_history_prev,
            ['<C-n>'] = actions.move_selection_next,
            ['<C-p>'] = actions.move_selection_previous,
            ['<C-s>'] = actions.file_split,
          },
          n = { q = actions.close },
        },
      },
      extensions = {
        ['ui-select'] = { cursor },
        zoxide = {
          ivy,
          prompt_title = 'Navigate deez nuts!',
        },
      },
    }

    telescope.load_extension 'ui-select'
    telescope.load_extension 'zoxide'

    map.normal {
      description = 'Switch to recently used folders',
      category = 'navigation',
      keys = '<c-z>',
      command = telescope.extensions.zoxide.list,
    }

    map.normal.visual.terminal {
      description = 'Search help files',
      category = 'help',
      keys = '<F1>',
      command = function() builtin.help_tags(dropdown) end,
    }

    map.normal {
      description = 'Open search for commands...',
      category = 'plugins',
      keys = '<C-p>',
      command = function() builtin.commands() end,
    }

    map.normal {
      description = 'Open search for all files...',
      category = 'search',
      keys = '<C-p><C-p>',
      command = function() builtin.find_files(ivy) end,
    }

    map.normal {
      description = 'Open search for all recent files...',
      category = 'search',
      keys = '<C-p><C-o>',
      command = function() builtin.oldfiles(ivy) end,
    }

    map.normal {
      description = 'Open search for keymaps...',
      category = 'search',
      keys = '<C-p><C-k>',
      command = function() builtin.keymaps(dropdown) end,
    }

    map.normal {
      description = 'Open search for symbols...',
      category = 'search',
      keys = '<C-p><C-s>',
      command = function() builtin.symbols(cursor) end,
    }

    map.normal {
      description = 'Open search for all file contents...',
      category = 'search',
      keys = '<C-p><C-g>',
      command = function() builtin.live_grep(ivy) end,
    }

    map.normal {
      description = 'Open search for current buffer content...',
      category = 'search',
      keys = '<C-p><C-b>',
      command = function() builtin.current_buffer_fuzzy_find(ivy) end,
    }

    map.normal {
      description = 'Open search for buffers...',
      category = 'search',
      keys = '<C-e>',
      command = function() builtin.buffers(cursor) end,
    }
  end,
}