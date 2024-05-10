require 'bugabinga.health'.add_dependency
{ name = 'CMake', name_of_executable = 'cmake', }
  { name_of_executable = 'make', }
  { name_of_executable = 'zig', }
  { name = 'TreeSitter CLI', name_of_executable = 'tree-sitter', }
  { name_of_executable = 'tar', }

local events = { 'VeryLazy', }
table.insert( events, vim.g.FILE_LOADED_EVENTS )

return {
  'nvim-treesitter/nvim-treesitter',
  -- version = '0.9.*',
  branch = 'master',
  event = events,
  init = function ( plugin )
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available
    -- during startup.
    require 'lazy.core.loader'.add_to_rtp( plugin )
    require 'nvim-treesitter.query_predicates'
  end,
  build = function ()
    require 'nvim-treesitter.install'.update { with_sync = false, }
  end,
  dependencies = {
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
    'RRethy/nvim-treesitter-endwise',
    'nvim-treesitter/nvim-treesitter-context',
    'nushell/tree-sitter-nu',
  },
  config = function ()
    local install = require 'nvim-treesitter.install'
    local configs = require 'nvim-treesitter.configs'

    install.prefer_git = false
    install.compilers = { 'zig', 'clang', 'gcc', 'cl', 'cc', vim.fn.getenv 'CC', }


    local should_disable = function ( _, bufnr )
      local max_filesize = 5 * 1024 * 1024 --MiB
      local ok, stats = pcall( vim.loop.fs_stat, vim.api.nvim_buf_get_name( bufnr or 0 ) )
      if ok and stats and stats.size > max_filesize then
        return true
      end
      return false
    end

    ---@diagnostic disable-next-line: missing-fields
    configs.setup {
      sync_install = false,
      ensure_installed = {
        'bash',
        'c',
        'comment',
        'diff',
        'dot',
        'dtd',
        'git_config',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'ini',
        'java',
        'just',
        'jsonc',
        'lua',
        'luap',
        'luadoc',
        'markdown',
        'markdown_inline',
        'muttrc',
        'nasm',
        'nix',
        'nu',
        'passwd',
        'pem',
        'properties',
        'proto',
        'printf',
        'query',
        'regex',
        'ssh_config',
        'toml',
        'udev',
        'vim',
        'vimdoc',
        'xml',
        'zig',
      },

      ignore_install = { 'oil', },

      auto_install = true,

      autotag = { enable = true, disable = should_disable, },
      endwise = { enable = true, disable = should_disable, },

      highlight = {
        enable = true,
        disable = should_disable,
        additional_vim_regex_highlighting = false,
      },

      incremental_selection = {
        enable = true,
        disable = should_disable,
        keymaps = {
          init_selection = '<up>',
          node_incremental = '<up>',
          node_decremental = '<down>',
          scope_incremental = '<right>',
        },
      },

      indent = { enable = true, },

      playground = {
        enable = true,
        disable = should_disable,
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
          disable = should_disable,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@call.outer', desc = 'outer function call', },
            ['if'] = { query = '@call.inner', desc = 'inner function call', },

            ['am'] = { query = '@function.outer', desc = 'outer function definition', },
            ['im'] = { query = '@function.inner', desc = 'inner function definition', },

            ['ac'] = { query = '@class.outer', desc = 'outer class', },
            ['ic'] = { query = '@class.inner', desc = 'inner class', },

            ['ai'] = { query = '@conditional.outer', desc = 'outer conditional', },
            ['ii'] = { query = '@conditional.inner', desc = 'inner conditional', },

            ['al'] = { query = '@loop.outer', desc = 'outer loop', },
            ['il'] = { query = '@loop.inner', desc = 'inner loop', },

            ['aa'] = { query = '@parameter.outer', desc = 'outer parameter', },
            ['ia'] = { query = '@parameter.inner', desc = 'inner parameter', },

            ['agc'] = { query = '@comment.outer', desc = 'outer comment', },
            ['igc'] = { query = '@comment.inner', desc = 'inner comment', },
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
          disable = should_disable,
          swap_next = {
            ['<leader>rwn'] = { query = '@parameter.inner', desc = 'Swap parameter with next', },
          },
          swap_previous = {
            ['<leader>rwp'] = { query = '@parameter.inner', desc = 'Swap parameter with previous', },
          },
        },

        lsp_interop = {
          enable = true,
          disable = should_disable,
          border = vim.g.border_style,
          floating_preview_opts = {},
          peek_definition_code = {
            ['<leader>lpf'] = { query = '@function.outer', desc = 'Peek definition of outer function.', },
            ['<leader>lpc'] = { query = '@class.outer', desc = 'Peek definition of outer class.', },
          },
        },

        move = {
          enable = true,
          disable = should_disable,
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
    require 'treesitter-context'.setup {
      enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20,     -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    }
  end,
}
