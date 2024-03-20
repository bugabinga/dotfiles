require 'bugabinga.health'.add_dependency
{
  name = 'ripgrep',
  name_of_executable = 'rg',
}
  {
    name = 'find-fd',
    name_of_executable = 'fd',
  }

local map = require 'std.map'
local icon = require 'std.icon'
local table = require 'std.table'

map.normal {
  description = 'Switch to recently used folders',
  category = 'navigation',
  keys = '<c-p><c-z>',
  command = function () require 'telescope'.extensions.zoxide.list() end,
}

map.normal.visual.terminal {
  description = 'Search help files',
  category = 'help',
  keys = '<F1>',
  command = function () require 'telescope.builtin'.help_tags() end,
}

map.normal {
  description = 'Open last search...',
  category = 'plugins',
  keys = '<c-p>',
  command = function () require 'telescope.builtin'.resume() end,
}

map.normal {
  description = 'Open search for all files...',
  category = 'search',
  keys = '<c-p><c-p>',
  command = function () require 'telescope.builtin'.find_files() end,
}

map.normal {
  description = 'Open search for keymaps...',
  category = 'search',
  keys = '<c-p><c-k>',
  command = function () require 'telescope.builtin'.keymaps() end,
}

map.normal {
  description = 'Open search for symbols...',
  category = 'search',
  keys = '<c-p><c-s>',
  command = function () require 'telescope.builtin'.symbols() end,
}

map.normal {
  description = 'Open search for all file contents...',
  category = 'search',
  keys = '<c-p><c-g>',
  command = function () require 'telescope.builtin'.live_grep() end,
}

map.normal {
  description = 'Open search for current buffer content...',
  category = 'search',
  keys = '<c-p><c-/>',
  command = function () require 'telescope.builtin'.current_buffer_fuzzy_find() end,
}

map.normal {
  description = 'Open search for buffers...',
  category = 'search',
  keys = '<c-e>',
  command = function () require 'telescope.builtin'.buffers() end,
}

return {
  'nvim-telescope/telescope.nvim',
  version = '0.*',
  cmd = 'Telescope',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'jvgrootveld/telescope-zoxide',
  },
  config = function ()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local themes = require 'telescope.themes'

    local ivy = themes.get_ivy { hidden = true, layout_config = { preview_width = 0.69, }, }
    local dropdown = themes.get_dropdown { layout_config = { width = 0.69, }, }
    local cursor = themes.get_cursor { layout_config = { preview_width = 0.42, width = 0.69, }, }

    telescope.setup {
      defaults = {
        path_display = { 'truncate', },
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = { prompt_position = 'bottom', preview_width = 0.69, },
          vertical = { mirror = false, },
          width = 0.69,
          height = 0.42,
          preview_cutoff = 124,
        },
        prompt_prefix = icon.telescope .. ' ',
        selection_caret = icon.arrow_right .. ' ',
        border = vim.g.border_style,
        file_ignore_patterns = {
          '.git/',
          '.svn/',
          '.cache',
          '%.o',
          '%.a',
          '%.out',
          '%.class',
          '%.pdf',
          '%.mkv',
          '%.mp4',
          '%.zip',
          '%.spl',
        },
        mappings = {
          i = {
            ['<c-j>'] = actions.cycle_history_next,
            ['<c-k>'] = actions.cycle_history_prev,
            ['<c-n>'] = actions.move_selection_next,
            ['<c-p>'] = actions.move_selection_previous,
            ['<c-s>'] = actions.file_split,
          },
          n = { q = actions.close, },
        },
      },
      pickers = {
        find_files = ivy,
        fd = ivy,
        keymaps = dropdown,
        diagnostics = dropdown,
        symbols = cursor,
        live_grep = ivy,
        current_buffer_fuzzy_find = cursor,
        buffers = cursor,
        help_tags = dropdown,
      },
      extensions = {
        ['ui-select'] = { cursor, },
        zoxide = { prompt_title = 'Navigate deez nuts!', },
      },
    }

    telescope.load_extension 'ui-select'
    telescope.load_extension 'zoxide'
  end,
}
