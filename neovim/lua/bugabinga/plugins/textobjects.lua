return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'master',
  event = 'VeryLazy',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function ()
    require 'nvim-treesitter.configs'.setup {
      textobjects = {
        select = {
          enable = true,
          disable = should_disable,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@call.outer', desc = 'outer function call' },
            ['if'] = { query = '@call.inner', desc = 'inner function call' },

            ['am'] = { query = '@function.outer', desc = 'outer function definition' },
            ['im'] = { query = '@function.inner', desc = 'inner function definition' },

            ['ai'] = { query = '@conditional.outer', desc = 'outer conditional' },
            ['ii'] = { query = '@conditional.inner', desc = 'inner conditional' },

            ['aa'] = { query = '@parameter.outer', desc = 'outer parameter' },
            ['ia'] = { query = '@parameter.inner', desc = 'inner parameter' },

            ['ac'] = { query = '@comment.outer', desc = 'outer comment' },
            ['ic'] = { query = '@comment.inner', desc = 'inner comment' },
          },
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'v',
            ['@class.outer'] = '<c-v>',
            ['@scope'] = 'v',
          },
          include_surroundig_whitespace = true,
        },

        move = {
          enable = true,
          disable = should_disable,
          set_jumps = true,
          goto_next = {
            [']m'] = { query = '@function.outer', desc = 'goto next function definition' },
          },
          goto_previous = {
            ['[m'] = { query = '@function.outer', desc = 'goto previous function definition' },
          },
        },
      },
    }
  end,
}
