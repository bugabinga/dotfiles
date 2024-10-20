local map = require 'std.map'

return {
  {
    'booperlv/nvim-gomove',
    commit = '2b44ae7ac0804f4e3959228122f7c85bef1964e3',
    event = 'VeryLazy',
    config = function ()
      local move = require 'gomove'

      move.setup {
        -- whether or not to map default key bindings, (true/false)
        map_defaults = false,
        -- whether or not to reindent lines moved vertically (true/false)
        reindent = true,
        -- whether or not to undojoin same direction moves (true/false)
        undojoin = true,
        -- whether to not to move past end column when moving blocks horizontally, (true/false)
        move_past_end_col = false,
      }

      -- default mappings in gomove set no options, but use old keymap api.
      -- recreating old defaults here:
      local options = { remap = true }

      -- i have tried using the lua functions directly for the commands below.
      -- the behaviour was slightly buggy in respects to block selections though.
      -- unsure why that is.

      -- NORMAL MOVE
      map.normal {
        description = 'Move character left',
        category = 'editing',
        keys = '<A-h>',
        options = options,
        command = '<Plug>GoNSMLeft',
      }
      map.normal {
        description = 'Move line down',
        category = 'editing',
        keys = '<A-j>',
        options = options,
        command = '<Plug>GoNSMDown',
      }
      map.normal {
        description = 'Move line up',
        category = 'editing',
        keys = '<A-k>',
        options = options,
        command = '<Plug>GoNSMUp',
      }
      map.normal {
        description = 'Move character right',
        category = 'editing',
        keys = '<A-l>',
        options = options,
        command = '<Plug>GoNSMRight',
      }

      -- VISUAL MOVE
      map.visual {
        description = 'Move block left',
        category = 'editing',
        keys = '<A-h>',
        options = options,
        command = '<Plug>GoVSMLeft',
      }
      map.visual {
        description = 'Move block down',
        category = 'editing',
        keys = '<A-j>',
        options = options,
        command = '<Plug>GoVSMDown',
      }
      map.visual {
        description = 'Move block up',
        category = 'editing',
        keys = '<A-k>',
        options = options,
        command = '<Plug>GoVSMUp',
      }
      map.visual {
        description = 'Move block right',
        category = 'editing',
        keys = '<A-l>',
        options = options,
        command = '<Plug>GoVSMRight',
      }

      -- NORMAL DUPLICATE
      map.normal {
        description = 'Duplicate character left',
        category = 'editing',
        keys = '<A-H>',
        options = options,
        command = '<Plug>GoNSDLeft',
      }
      map.normal {
        description = 'Duplicate line down',
        category = 'editing',
        keys = '<A-J>',
        options = options,
        command = '<Plug>GoNSDDown',
      }
      map.normal {
        description = 'Duplicate line up',
        category = 'editing',
        keys = '<A-K>',
        options = options,
        command = '<Plug>GoNSDUp',
      }
      map.normal {
        description = 'Duplicate character right',
        category = 'editing',
        keys = '<A-L>',
        options = options,
        command = '<Plug>GoNSDRight',
      }

      -- VISUAL DUPLICATE
      map.visual {
        description = 'Duplicate block left',
        category = 'editing',
        keys = '<A-H>',
        options = options,
        command = '<Plug>GoVSDLeft',
      }
      map.visual {
        description = 'Duplicate block down',
        category = 'editing',
        keys = '<A-J>',
        options = options,
        command = '<Plug>GoVSDDown',
      }
      map.visual {
        description = 'Duplicate block up',
        category = 'editing',
        keys = '<A-K>',
        options = options,
        command = '<Plug>GoVSDUp',
      }
      map.visual {
        description = 'Duplicate block right',
        category = 'editing',
        keys = '<A-L>',
        options = options,
        command = '<Plug>GoVSDRight',
      }
    end,
  },
}
