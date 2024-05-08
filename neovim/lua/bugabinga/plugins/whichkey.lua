local ignored = require 'std.ignored'
local icon = require 'std.icon'

return {
  'folke/which-key.nvim',
  version = '1.*',
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
    layout = { align = 'center', },
    disable = {
      buftypes = ignored.buftypes,
    },
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
        ['7'] = { name = 'tests', _ = 'which_key_ignore', },
        m = { name = '|m|ark', _ = 'which_key_ignore', },
        b = { name = '|b|uffer', _ = 'which_key_ignore', },
        h = { name = '|h|unk', _ = 'which_key_ignore', },
        f = { name = '|f|iles', _ = 'which_key_ignore', },
        g = { name = '|g|enerate', _ = 'which_key_ignore', },
        d = { name = '|d|ebug', _ = 'which_key_ignore', },
        v = { name = '|v|ersion control', _ = 'which_key_ignore', },
        s = { name = '|s|essions', _ = 'which_key_ignore', },
        r = { name = '|r|efactor', _ = 'which_key_ignore', },
        w = { name = 's|w|ap', _ = 'which_key_ignore',
          {
            p = { name = '|p|arameter', _ = 'which_key_ignore', },
          },
        },
        l = { name = '|l|sp', _ = 'which_key_ignore',
          p = { name = '|p|eek', _ = 'which_key_ignore', },
          c = { name = '|c|alls', _ = 'which_key_ignore', },
        },
        t = { name = '|t|oggle', _ = 'which_key_ignore',
          {
            o = { name = '|o|ptions', _ = 'which_key_ignore', },
          },
        },
        z = { name = 'la|z|y', _ = 'which_key_ignore', },
        [' '] = { name = 'fun', _ = 'which_key_ignore', },
      },
    }
  end,
}
