require 'bugabinga.health'.add_dependency
{
  name = 'ripgrep',
  name_of_executable = 'rg',
}
  {
    name = 'find-fd',
    name_of_executable = 'fd',
  }
  {
    name = 'CMake',
    name_of_executable = 'cmake',
  }

local map = require 'std.map'
local icon = require 'std.icon'

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

map.normal {
  description = 'Open clipboard history...',
  category = 'history',
  keys = '<c-p><c-v>',
  command = function ()
    require 'telescope'.extensions.neoclip.default()
  end,
}

return {
  'nvim-telescope/telescope.nvim',
  version = '0.*',
  cmd = 'Telescope',
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build =
        function ( plugin_spec )
          local result
          result = vim.system( { 'cmake', '-S.', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release', },
                               { text = true, cwd = plugin_spec.dir, } ):wait()
          if result.code ~= 0 then error( result.stderr ) end
          result = vim.system( { 'cmake', '--build', 'build', '--config', 'Release', },
                               { text = true, cwd = plugin_spec.dir, } ):wait()
          if result.code ~= 0 then error( result.stderr ) end
          result = vim.system( { 'cmake', '--install', 'build', '--prefix', 'build', },
                               { text = true, cwd = plugin_spec.dir, } ):wait()
          if result.code ~= 0 then error( result.stderr ) end
        end,
    },
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope-symbols.nvim',
    'jvgrootveld/telescope-zoxide',
    'AckslD/nvim-neoclip.lua',
  },
  config = function ()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local themes = require 'telescope.themes'

    local ivy = themes.get_ivy { hidden = true, layout_config = { preview_width = 0.69, }, }

    telescope.setup {
      defaults = {
        hidden = true,
        prompt_prefix = icon.telescope .. ' ',
        selection_caret = icon.arrow_right .. ' ',
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
            ['g?'] = actions.which_key,
          },
          n = { q = actions.close, },
        },
      },
      pickers = {
        find_files = ivy,
        fd = ivy,
        keymaps = ivy,
        diagnostics = ivy,
        symbols = ivy,
        live_grep = ivy,
        current_buffer_fuzzy_find = ivy,
        buffers = ivy,
        help_tags = ivy,
      },
      extensions = {
        zoxide = { prompt_title = 'Navigate deez nuts!', },
      },
    }

    require 'neoclip'.setup()

    telescope.load_extension 'fzf'
    telescope.load_extension 'zoxide'
    telescope.load_extension 'neoclip'
  end,
}
