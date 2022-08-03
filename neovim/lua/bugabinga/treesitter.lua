local want = require 'bugabinga.std.want'
want {
  'nvim-treesitter.install',
  'nvim-treesitter.configs',
  'nvim-treesitter.parsers',
  'hlargs',
  'neogen',
}(function(install, configs, parsers, hlargs, neogen)
  install.compilers = { 'zig', 'clang', 'gcc', 'cl', 'cc', vim.fn.getenv 'CC' }
  install.prefer_git = true

  configs.setup {
    -- A list of parser names, or "all"
    ensure_installed = {
      'c',
      'bash',
      'cmake',
      'comment',
      'cpp',
      'css',
      'dockerfile',
      'dot',
      'help',
      'html',
      'http',
      'java',
      'javascript',
      'json',
      'json5',
      'jsonc',
      'llvm',
      'lua',
      'make',
      'markdown',
      'ninja',
      'proto',
      'python',
      'query',
      'regex',
      'rust',
      'toml',
      'vim',
      'yaml',
      'zig',
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,
    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      disable = {},

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    -- indent on = with TS
    indent = {
      enable = true,
    },
    -- These features are mostly useful when there is treesitter parser, but no
    -- LSP.
    -- FIXME harmonize the keybinds with LSP equivalents
    refactor = {
      highlight_definitions = {
        enable = true,
        -- Set to false if you have an `updatetime` of ~100.
        clear_on_cursor_move = false,
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = 'grr',
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = 'gnd',
          list_definitions = 'gnD',
          list_definitions_toc = 'gO',
          goto_next_usage = '<a-*>',
          goto_previous_usage = '<a-#>',
        },
      },
    },
    textsubjects = {
      enable = true,
      prev_selection = '<Down>', -- (Optional) keymap to select the previous selection
      keymaps = {
        ['<Up>'] = 'textsubjects-smart',
        ['<Right>'] = 'textsubjects-container-outer',
        ['<Left>'] = 'textsubjects-container-inner',
      },
    },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      lsp_interop = {
        enable = true,
        border = 'none',
        peek_definition_code = {
          ['<leader>df'] = '@function.outer',
          ['<leader>dc'] = '@class.outer',
        },
      },
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
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
    context_commentstring = {
      enable = true,
    },
    -- autoclose and rename tags
    autotag = {
      enable = true,
    },
  }

  parsers.get_parser_configs().just = {
    install_info = {
      url = 'https://github.com/IndianBoy42/tree-sitter-just', -- local path or git repo
      files = { 'src/parser.c', 'src/scanner.cc' },
      branch = 'main',
    },
    maintainers = { '@IndianBoy42' },
  }

  -- highlight function arguments
  hlargs.setup()

  -- generate doc comment annotations
  neogen.setup()
end)
