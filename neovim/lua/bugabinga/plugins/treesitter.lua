local map = require 'std.map'

require 'bugabinga.health'.add_dependency
{
  name = 'CMake',
  name_of_executable = 'cmake',
}
  {
    name_of_executable = 'make',
  }
  {
    name_of_executable = 'zig',
  }
  {
    name = 'TreeSitter CLI',
    name_of_executable = 'tree-sitter',
  }
  {
    name_of_executable = 'tar',
  }

return {
  'nvim-treesitter/nvim-treesitter',
  tag = 'v0.9.2',
  -- branch = 'master',
  event = { 'BufReadPre', 'BufNewFile', },
  build = function ()
    require 'nvim-treesitter.install'.update { with_sync = true, }
  end,
  dependencies = {
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nushell/tree-sitter-nu',
  },
  config = function ()
    local install = require 'nvim-treesitter.install'
    local configs = require 'nvim-treesitter.configs'
    local parsers = require 'nvim-treesitter.parsers'

    install.prefer_git = false
    install.compilers = { 'zig', 'clang', 'gcc', 'cl', 'cc', vim.fn.getenv 'CC', }

    ---@diagnostic disable-next-line: missing-fields
    configs.setup {

      sync_install = false,

      ensure_installed = {
        'bash',
        'c',
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/5389
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
        'nu',
        'lua',
        'luap',
        'luadoc',
        'regex',
        'vim',
        'vimdoc',
        'query',
        'zig',
      },

      ignore_install = { 'oil', },

      auto_install = true,

      autotag = { enable = true, },

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
          node_decremental = '<down>',
          scope_incremental = '<up>',
        },
      },

      indent = { enable = true, },

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
          swap_next = {
            ['<leader>spn'] = { query = '@parameter.inner', desc = 'Swap parameter with next', },
          },
          swap_previous = {
            ['<leader>spp'] = { query = '@parameter.inner', desc = 'Swap parameter with previous', },
          },
        },

        lsp_interop = {
          enable = true,
          border = vim.g.border_style,
          floating_preview_opts = {},
          peek_definition_code = {
            ['<leader>lpf'] = { query = '@function.outer', desc = 'Peek definition of outer function.', },
            ['<leader>lpc'] = { query = '@class.outer', desc = 'Peek definition of outer class.', },
          },
        },

        move = {
          enable = true,
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

    ---@diagnostic disable-next-line: inject-field
    parsers.get_parser_configs().just = {
      install_info = {
        url = 'https://github.com/IndianBoy42/tree-sitter-just', -- local path or git repo
        files = { 'src/parser.c', 'src/scanner.cc', },
        branch = 'main',
      },
      maintainers = { '@IndianBoy42', },
    }
  end,
}
