---@diagnostic disable: missing-fields

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-path',
    { 'L3MON4D3/LuaSnip', version = '2.*', build = 'make install_jsregexp' },
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    'onsails/lspkind.nvim',
  },
  config = function ()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    require 'luasnip.loaders.from_vscode'.lazy_load()

    cmp.setup {
      completion = {
        autocomplete = false,
        completeopt = 'menu,menuone,preview,noselect',
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol',
          maxwidth = 75,
          ellipsis_char = '…',
        },
      },
      snippet = { expand = function ( args ) luasnip.lsp_expand( args.body ) end },
      mapping = {
        ['<c-p>'] = cmp.mapping.select_prev_item(),
        ['<c-n>'] = cmp.mapping.select_next_item(),
        ['<c-k>'] = cmp.mapping.select_prev_item(),
        ['<c-j>'] = cmp.mapping.select_next_item(),
        ['<s-tab>'] = cmp.mapping.select_prev_item(),
        ['<tab>'] = cmp.mapping.select_next_item(),
        ['<c-b>'] = cmp.mapping.scroll_docs( -2 ),
        ['<c-f>'] = cmp.mapping.scroll_docs( 2 ),
        ['<c-u>'] = cmp.mapping.scroll_docs( -4 ),
        ['<c-d>'] = cmp.mapping.scroll_docs( 4 ),
        ['<c-space>'] = cmp.mapping.complete {},
        ['<esc>'] = cmp.mapping.abort(),
        ['<cr>'] = cmp.mapping.confirm { select = false }
      },
      sources = cmp.config.sources {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
      }
    }

    cmp.setup.filetype( 'gitcommit', {
      sources = cmp.config.sources {
        { name = 'git' },
      },
      {
        { name = 'buffer' },
        { name = 'path' },
      }
    } )

    cmp.setup.cmdline( '/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    } )

    cmp.setup.cmdline( '?', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    } )

    cmp.setup.cmdline( ':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources {
        { name = 'path' }
      },
      {
        { name = 'cmdline' }
      }
    } )
  end,
}
