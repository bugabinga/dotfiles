require 'bugabinga.health'.add_dependency
{ name = 'CMake', name_of_executable = 'cmake' }
  { name_of_executable = 'make' }
  { name_of_executable = 'zig' }
  { name = 'TreeSitter CLI', name_of_executable = 'tree-sitter' }
  { name_of_executable = 'tar' }

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  lazy = false,
  build = function ()
    require 'nvim-treesitter.install'.update { with_sync = true }
  end,
  dependencies = {
    -- FIXME: move nvim-treesitter modules out into normal config to prepare for main branch
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
    'RRethy/nvim-treesitter-endwise',
    'nushell/tree-sitter-nu',
  },
  config = function ()
    local install = require 'nvim-treesitter.install'
    local configs = require 'nvim-treesitter.configs'

    install.prefer_git = false
    install.compilers = { 'zig cc', 'clang', 'gcc', 'cl', 'cc', vim.fn.getenv 'CC' }

    local should_disable = function ( _, bufnr )
      local max_filesize = 5 * 1024 * 1024 --MiB
      ---@diagnostic disable-next-line: undefined-field
      local ok, stats = pcall( vim.loop.fs_stat, vim.api.nvim_buf_get_name( bufnr or 0 ) )
      if ok and stats and stats.size > max_filesize then
        return true
      end
      return false
    end

    ---@diagnostic disable-next-line: missing-fields
    configs.setup {
      sync_install = false,
      ignore_install = { 'oil' },
      auto_install = true,

      autotag = { enable = true, disable = should_disable },
      endwise = { enable = true, disable = should_disable },

      highlight = {
        enable = true,
        disable = should_disable,
        additional_vim_regex_highlighting = false,
      },

      incremental_selection = {
        enable = true,
        disable = should_disable,
        keymaps = {
          -- FIXME: not too happy with these binds. but i dont feel better ones right now.
          init_selection = '<up>',
          node_incremental = '<up>',
          node_decremental = '<down>',
          scope_incremental = '<right>',
        },
      },

      indent = { enable = true, disable = should_disable },

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
            ['@scope'] = 'V',
          },
          include_surroundig_whitespace = true,
        },

        move = {
          enable = true,
          disable = should_disable,
          set_jumps = true,
          goto_next = {
            [']m'] = { query = '@function.outer', desc = 'Goto next function definition' },
          },
          goto_previous = {
            ['[m'] = { query = '@function.outer', desc = 'Goto previous function definition' },
          },
        },
      },
    }
  end,
}
