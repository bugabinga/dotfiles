local map = require 'std.map'

require 'bugabinga.health'.add_dependency
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
  branch = 'master',
  event = 'BufRead',
  cmd = {
    'TSBufDisable',
    'TSBufEnable',
    'TSBufToggle',
    'TSDisable',
    'TSEnable',
    'TSToggle',
    'TSInstall',
    'TSInstallInfo',
    'TSInstallSync',
    'TSModuleInfo',
    'TSUninstall',
    'TSUpdate',
    'TSUpdateSync',
    'TSPlaygroundToggle',
    'TSHighlightCapturesUnderCursor',
    'TSNodeUnderCursor',
  },
  build = function ()
    require 'nvim-treesitter.install'.update { with_sync = true }
  end,
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function ()
    local install = require 'nvim-treesitter.install'
    local configs = require 'nvim-treesitter.configs'
    local parsers = require 'nvim-treesitter.parsers'

    install.prefer_git = false
    install.compilers = { 'zig', 'clang', 'gcc', 'cl', 'cc', vim.fn.getenv 'CC' }

    ---@diagnostic disable-next-line: missing-fields
    configs.setup {

      sync_install = false,

      ensure_installed = {
        'bash',
        'c',
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/5389
        -- 'comment',
        'diff',
        'dot',
        'git_config',
        'gitcommit',
        'gitignore',
        'java',
        'jsonc',
        'markdown',
        'markdown_inline',
        'lua',
        'luap',
        'luadoc',
        'regex',
        'vim',
        'vimdoc',
        'query',
        'zig',
      },

      ignore_install = { 'oil' },

      auto_install = true,

      autotag = { enable = true },

      context_commentstring = { enable = true, enable_autocmd = false },

      highlight = {
        enable = true,
        disable = function ( _, buf )
          local max_filesize = 1000 * 1024 -- 1000 KiB
          local ok, stats = pcall( vim.loop.fs_stat, vim.api.nvim_buf_get_name( buf ) )
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<up>',
          node_incremental = '<right>',
          node_decremental = '<left>',
          scope_incremental = false,
        },
      },

      indent = { enable = true },

      playground = {
        enable = true,
        disable = {},
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
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',

            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',

            ['at'] = '@comment.outer',
            ['it'] = '@comment.inner',

            ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
          },
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V',  -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
            ['@scope'] = 'V',
          },
          include_surroundig_whitespace = true,
        },

        swap = {
          enable = true,
          swap_next = {
            ['<leader>sn'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>sp'] = '@parameter.inner',
          },
        },

        lsp_interop = {
          enable = true,
          border = vim.g.border_style,
          floating_preview_opts = {},
          peek_definition_code = {
            ['<c-)>'] = '@function.outer',
            ['<c-a-)>'] = '@class.outer',
          },
        },

        move = {
          enable = true,
          set_jumps = true,
          goto_next = {
            [']f'] = '@function.outer',
            [']c'] = { query = '@class.outer', desc = 'Next class start' },
            [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
            [']i'] = '@conditional.outer',
            [']a'] = '@parameter.outer',
          },
          goto_previous = {
            ['[f'] = '@function.outer',
            ['[c'] = { query = '@class.outer', desc = 'Previous class start' },
            ['[s'] = { query = '@scope', query_group = 'locals', desc = 'Previous scope' },
            ['[i'] = '@conditional.outer',
            ['[a'] = '@parameter.outer',
          }
        },
      }
    }

    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

    map.normal.visual.operator_pending {
      description = 'This repeats the last query with always previous direction and to the start of the range.',
      keys = '<PageUp>',
      category = 'textobjects',
      command = function () ts_repeat_move.repeat_last_move { forward = false } end
    }

    map.normal.visual.operator_pending {
      description = 'This repeats the last query with always next direction and to the end of the range.',
      keys = '<PageDown>',
      category = 'textobjects',
      command = function () ts_repeat_move.repeat_last_move { forward = true } end
    }

    ---@diagnostic disable-next-line: inject-field
    parsers.get_parser_configs().just = {
      install_info = {
        url = 'https://github.com/IndianBoy42/tree-sitter-just', -- local path or git repo
        files = { 'src/parser.c', 'src/scanner.cc' },
        branch = 'main',
      },
      maintainers = { '@IndianBoy42' },
    }
  end,
}