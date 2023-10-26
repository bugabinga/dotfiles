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
  {
    name_of_executable = 'curl'
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
    'RRethy/nvim-treesitter-endwise',
  },
  config = function ()
    local install = require 'nvim-treesitter.install'
    local configs = require 'nvim-treesitter.configs'
    local parsers = require 'nvim-treesitter.parsers'
    -- nvim-treesitter assumes that windows users use either cmd or powershell.
    -- my win32 + nushell combination does not work well.
    -- override some internal functions  of nvim-treesitter for nushell support.
    local shell = require 'nvim-treesitter.shell_command_selectors'
    shell.make_directory_change_for_command = function ( dir, command )
      return string.format( 'cd %s; %s', dir, command )
    end
    shell.select_mv_cmd = function ( from, to, cwd )
      return {
        cmd = 'mv',
        opts = {
          args = { '--force', from, to },
          cwd = cwd,
        }
      }
    end
    shell.select_install_rm_cmd = function ( cache_folder, project_name )
      local project = vim.fs.joinpath( cache_folder, project_name )
      return {
        cmd = 'rm',
        opts = {
          args = {
            '--recursive',
            '--force',
            '--permanent',
            project,
          }
        },
        err = 'Could not delete project ' .. project,
      }
    end
    shell.select_rm_file_cmd = function ( file, info_msg )
      return {
        cmd  = 'rm',
        opts = {
          args = { '--force', '--permanent', file }
        },
        info = info_msg,
        err  = 'Could not delete file ' .. file,
      }
    end
    shell.select_mkdir_cmd = function ( directory, cwd, info_msg )
      return {
        cmd = 'mkdir',
        opts = {
          args = { directory },
          cwd = cwd,
        },
        info = info_msg,
        err = 'Could not create directory ' .. directory,
      }
    end

    install.prefer_git = false
    install.compilers = { 'zig' }

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
        'xml',
        'zig',
      },

      ignore_install = { 'oil' },

      auto_install = true,

      autotag = {
        enable = true,
        filetypes = {
          'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript', 'css', 'lua', 'xml', 'php', 'markdown'
        },
      },

      endwise = { enable = true },

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
            ['af'] = { query = '@function.outer', desc = 'Select outer function' },
            ['if'] = { query = '@function.inner', desc = 'Select inner function' },

            ['ac'] = { query = '@class.outer', desc = 'Select outer class' },
            ['ic'] = { query = '@class.inner', desc = 'Select inner class' },

            ['at'] = { query = '@comment.outer', desc = 'Select outer comment' },

            ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
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
          swap_next = {
            ['<leader>sn'] = { query = '@parameter.inner', desc = 'Swap parameter with next' },
          },
          swap_previous = {
            ['<leader>sp'] = { query = '@parameter.inner', desc = 'Swap parameter with previous' },
          },
        },

        lsp_interop = {
          enable = true,
          border = vim.g.border_style,
          floating_preview_opts = {},
          peek_definition_code = {
            ['<leader>lpf'] = { query = '@function.outer', desc = 'Peek definition of outer function.' },
            ['<leader>lpc'] = { query = '@class.outer', desc = 'Peek definition of outer class.' },
          },
        },

        move = {
          enable = true,
          set_jumps = true,
          goto_next = {
            [']f'] = { query = '@function.outer', desc = 'Goto next funtion' },
            [']c'] = { query = '@class.outer', desc = 'Goto next class' },
            [']s'] = { query = '@scope', query_group = 'locals', desc = 'Goto next scope' },
            [']i'] = { query = '@conditional.outer', desc = 'Goto next conditional' },
            [']a'] = { query = '@parameter.outer', desc = 'Goto next parameter' },
          },
          goto_previous = {
            ['[f'] = { query = '@function.outer', desc = 'Goto previous function' },
            ['[c'] = { query = '@class.outer', desc = 'goto previous class' },
            ['[s'] = { query = '@scope', query_group = 'locals', desc = 'Goto previous scope' },
            ['[i'] = { query = '@conditional.outer', desc = 'Goto previous conditional' },
            ['[a'] = { query = '@parameter.outer', desc = 'Goto previous parameter' },
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
