local icon = require 'std.icon'

-- TODO: replace with vim.completion, once it lands

return {
  'hrsh7th/nvim-cmp',
  branch = 'main',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind.nvim',
    'L3MON4D3/LuaSnip',
  },
  config = function ()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local MAX_INDEX_FILE_SIZE = 4000

    local snippet_next = function ( fallback )
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end

    local snippet_prev = function ( fallback )
      if luasnip.jumpable( -1 ) then
        luasnip.jump( -1 )
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end

    local mapping = cmp.mapping.preset.insert {
      ['<C-d>'] = cmp.mapping.scroll_docs( -4 ),
      ['<C-f>'] = cmp.mapping.scroll_docs( 4 ),
      ['<C-c>'] = cmp.mapping.close(),
      ['<C-y>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
      ['<C-x>'] = cmp.mapping.complete(),
    }

    local formatting = {}
    local ok, lspkind = pcall( require, 'lspkind' )
    if ok then
      formatting.format = lspkind.cmp_format {
        mode = 'symbol',
        symbol_map = {
          Copilot = icon.copilot,
          Class = icon.class,
          Color = icon.color,
          Constant = icon.constant,
          Constructor = icon.constructor,
          Enum = icon.enum,
          EnumMember = icon.enum_member,
          Event = icon.event,
          Field = icon.field,
          File = icon.file,
          Folder = icon.folder,
          Function = icon['function'],
          Interface = icon.interface,
          Keyword = icon.keyword,
          Method = icon.method,
          Module = icon.module,
          Operator = icon.operator,
          Property = icon.property,
          Reference = icon.reference,
          Snippet = icon.snippet,
          Struct = icon.struct,
          Text = icon.text,
          TypeParameter = icon.type_parameter,
          Unit = icon.unit,
          Value = icon.value,
          Variable = icon.variable,
        },
        menu = {
          buffer = '[buf]',
          nvim_lsp = '[LSP]',
          nvim_lua = '[nvim]',
          path = '[path]',
          luasnip = '[snip]',
        },
      }
    end

    local sources = {
      { name = 'nvim_lua' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'luasnip' },
      {
        name = 'buffer',
        keyword_length = 4,
        options = {
          get_bufnrs = function ()
            local bufs = {}
            for _, bufnr in ipairs( vim.api.nvim_list_bufs() ) do
              -- Don't index giant files
              if vim.api.nvim_buf_is_loaded( bufnr ) and vim.api.nvim_buf_line_count( bufnr ) < MAX_INDEX_FILE_SIZE then
                table.insert( bufs, bufnr )
              end
            end
            return bufs
          end,
        },
      },
    }

    cmp.setup {
      mapping = mapping,
      formatting = formatting,
      sources = sources,

      completion = { autocomplete = false },
      snippet = {
        expand = function ( args ) luasnip.lsp_expand( args.body ) end,
      },
    }
  end,
}
