---@diagnostic disable: missing-fields

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp-document-symbol',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-emoji',
    { 'L3MON4D3/LuaSnip', version = '2.*' },
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
      performance = {
        debounce = 150,
        throttle = 300,
        fetching_timeout = 400,
      },
      completion = {
        autocomplete = false,
        completeopt = 'menu,menuone,preview,noselect',
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol',
          maxwidth = 75,
          ellipsis_char = '…',
        },
      },
      -- experimental = { ghost_text = true, },
      preselect = cmp.PreselectMode.None,
      snippet = { expand = function ( args ) luasnip.lsp_expand( args.body ) end },
      mapping = {
        ['<c-p>'] = cmp.mapping.select_prev_item(),
        ['<c-n>'] = cmp.mapping.select_next_item(),
        ['<c-k>'] = cmp.mapping.select_prev_item(),
        ['<c-j>'] = cmp.mapping.select_next_item(),
        ['<tab>'] = cmp.mapping( function ( fallback )
                                   if cmp.visible() then
                                     cmp.select_next_item()
                                   elseif luasnip.expand_or_locally_jumpable() then
                                     luasnip.expand_or_jump()
                                   else
                                     fallback()
                                   end
                                 end, { 'i', 's' } ),
        ['<s-tab>'] = cmp.mapping( function ( fallback )
                                     if cmp.visible() then
                                       cmp.select_prev_item()
                                     elseif luasnip.locally_jumpable( -1 ) then
                                       luasnip.jump( -1 )
                                     else
                                       fallback()
                                     end
                                   end, { 'i', 's' } ),
        ['<c-b>'] = cmp.mapping.scroll_docs( -2 ),
        ['<c-f>'] = cmp.mapping.scroll_docs( 2 ),
        ['<c-u>'] = cmp.mapping.scroll_docs( -4 ),
        ['<c-d>'] = cmp.mapping.scroll_docs( 4 ),
        ['<c-space>'] = cmp.mapping.complete {},
        ['<esc>'] = cmp.mapping.abort(),
        ['<cr>'] = cmp.mapping.confirm {
          behaviour = cmp.ConfirmBehavior.Replace,
          select = true,
        }
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_document_symbol' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'emoji' },
        { name = 'buffer',                  keyword_length = 3 },
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
  end,
}
