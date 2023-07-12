local map = require 'std.keymap'

return {
  {
    'booperlv/nvim-gomove',
    keys = {
      { '<A-h>', nil, mode = { 'n', 'x' } },
      { '<A-j>', nil, mode = { 'n', 'x' } },
      { '<A-k>', nil, mode = { 'n', 'x' } },
      { '<A-l>', nil, mode = { 'n', 'x' } },

      { '<A-H>', nil, mode = { 'n', 'x' } },
      { '<A-J>', nil, mode = { 'n', 'x' } },
      { '<A-K>', nil, mode = { 'n', 'x' } },
      { '<A-L>', nil, mode = { 'n', 'x' } },
    },
    config = function()
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
        name = 'Move character left',
        category = 'editing',
        keys = '<A-h>',
        options = options,
				command = '<Plug>GoNSMLeft',
      }
      map.normal {
        name = 'Move line down',
        category = 'editing',
        keys = '<A-j>',
        options = options,
				command = '<Plug>GoNSMDown',
      }
      map.normal {
        name = 'Move line up',
        category = 'editing',
        keys = '<A-k>',
        options = options,
				command = '<Plug>GoNSMUp',
      }
      map.normal {
        name = 'Move character right',
        category = 'editing',
        keys = '<A-l>',
        options = options,
				command = '<Plug>GoNSMRight',
      }

      -- VISUAL MOVE
      map.visual {
        name = 'Move block left',
        category = 'editing',
				keys = '<A-h>',
        options = options,
				command = '<Plug>GoVSMLeft',
      }
      map.visual {
        name = 'Move block down',
        category = 'editing',
        keys = '<A-j>',
        options = options,
				command = '<Plug>GoVSMDown',
      }
      map.visual {
        name = 'Move block up',
        category = 'editing',
        keys = '<A-k>',
        options = options,
				command = '<Plug>GoVSMUp',
      }
      map.visual {
        name = 'Move block right',
        category = 'editing',
        keys = '<A-l>',
        options = options,
				command = '<Plug>GoVSMRight',
      }

      -- NORMAL DUPLICATE
      map.normal {
        name = 'Duplicate character left',
        category = 'editing',
        keys = '<A-H>',
        options = options,
				command = '<Plug>GoNSDLeft',
      }
      map.normal {
        name = 'Duplicate line down',
        category = 'editing',
        keys = '<A-J>',
        options = options,
				command = '<Plug>GoNSDDown',
      }
      map.normal {
        name = 'Duplicate line up',
        category = 'editing',
        keys = '<A-K>',
        options = options,
				command = '<Plug>GoNSDUp',
      }
      map.normal {
        name = 'Duplicate character right',
        category = 'editing',
        keys = '<A-L>',
        options = options,
				command = '<Plug>GoNSDRight',
      }

      -- VISUAL DUPLICATE
      map.visual {
        name = 'Duplicate block left',
        category = 'editing',
        keys = '<A-H>',
        options = options,
				command = '<Plug>GoVSDLeft',
      }
      map.visual {
        name = 'Duplicate block down',
        category = 'editing',
        keys = '<A-J>',
        options = options,
				command = '<Plug>GoVSDDown',
      }
      map.visual {
        name = 'Duplicate block up',
        category = 'editing',
        keys = '<A-K>',
        options = options,
				command = '<Plug>GoVSDUp',
      }
      map.visual {
        name = 'Duplicate block right',
        category = 'editing',
        keys = '<A-L>',
        options = options,
				command = '<Plug>GoVSDRight',
      }
    end,
  },
}
