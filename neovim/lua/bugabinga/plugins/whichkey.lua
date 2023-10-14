local ignored = require 'std.ignored'
local icon = require 'std.icon'

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function ()
    vim.o.timeout = true
    vim.o.timeoutlen = 250
  end,
  opts = {
    key_labels = {
      ['<space>']  = icon.space_key,
      ['<cr>']     = icon.return_key,
      ['<tab>']    = icon.tab_key,
      ['<esc>']    = icon.esc_key,
      ['<bs>']     = icon.backspace_key,
      ['<leader>'] = icon.leader_key,
    },
    icons = {
      group = icon.group,
    },
    window = {
      border = vim.g.border_style,
      winblend = vim.o.winblend,
    },
    layout = { align = 'center' },
    disable = {
      buftypes = ignored.buftypes,
    }
  },
  config = function ( _, opts )
    local wk = require 'which-key'
    wk.setup( opts )

    -- TODO: how can my own map api be used to generate the following wk prefixes?
    -- map should not depend on wk.
    -- can map cache mappings to read here?
    -- use category as prefix?
    wk.register {
      ['<leader>'] = {
        m = { name = 'mark' }, -- FIXME: this prefix does not show up. why?
        l = { name = 'lsp' },
        s = {
          name = 'swap',
          {
            p = { name = 'parameter' },
          },
        },
        g = { name = 'generate' },
        t = {
          name = 'toggle',
          {
            o = { name = 'options' },
          }
        },
        z = { name = 'lazy' },
        [' '] = { name = 'fun' },
      }
    }
  end
}
