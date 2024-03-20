local map = require 'std.map'
local ignored = require 'std.ignored'

map.normal {
  description = 'Find cursor!',
  category = 'fun',
  keys = '<leader><leader>',
  command = function () require 'specs'.show_specs() end,
}

map.normal {
  description = 'Find cursor, for real!',
  category = 'fun',
  keys = '<leader><leader><leader>',
  command = function ()
    require 'specs'.show_specs { width = 69, delay_ms = 69, inc_ms = 42, }
  end,
}

return {
  'KevinSilvester/specs.nvim',
  opts = function ()
    return {
      show_jumps       = true,
      min_jump         = 30,
      popup            = {
        delay_ms = 10, -- delay before popup displays
        inc_ms = 10, -- time increments used for fade/resize effects
        blend = 10,  -- starting blend, between 0-100 (fully transparent), see :h winblend
        width = 10,
        winhl = 'Cursor',
        fader = require 'specs'.exp_fader,
        resizer = require 'specs'.shrink_resizer,
      },
      ignore_filetypes = ignored.filetypes_kv,
      ignore_buftypes  = ignored.buftypes_kv,
    }
  end
  ,
}
