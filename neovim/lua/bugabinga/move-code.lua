local want = require 'bugabinga.std.want'
local map = require 'bugabinga.std.keymap'

want { 'gomove' }(function(move)
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
  map {
    description = 'Move character left',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoNSMLeft',
    mode = map.MODE.NORMAL,
    keys = map.KEY.ALT_H,
    options = options,
  }
  map {
    description = 'Move line down',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoNSMDown',
    mode = map.MODE.NORMAL,
    keys = map.KEY.ALT_J,
    options = options,
  }
  map {
    description = 'Move line up',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoNSMUp',
    mode = map.MODE.NORMAL,
    keys = map.KEY.ALT_K,
    options = options,
  }
  map {
    description = 'Move character right',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoNSMRight',
    mode = map.MODE.NORMAL,
    keys = map.KEY.ALT_L,
    options = options,
  }

  -- VISUAL MOVE
  map {
    description = 'Move block left',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoVSMLeft',
    mode = map.MODE.VISUAL,
    keys = map.KEY.ALT_H,
    options = options,
  }
  map {
    description = 'Move block down',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoVSMDown',
    mode = map.MODE.VISUAL,
    keys = map.KEY.ALT_J,
    options = options,
  }
  map {
    description = 'Move block up',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoVSMUp',
    mode = map.MODE.VISUAL,
    keys = map.KEY.ALT_K,
    options = options,
  }
  map {
    description = 'Move block right',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoVSMRight',
    mode = map.MODE.VISUAL,
    keys = map.KEY.ALT_K,
    options = options,
  }

  -- NORMAL DUPLICATE
  map {
    description = 'Duplicate character left',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoNSDLeft',
    mode = map.MODE.NORMAL,
    keys = map.KEY.ALT_SHIFT_H,
    options = options,
  }
  map {
    description = 'Duplicate line down',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoNSDDown',
    mode = map.MODE.NORMAL,
    keys = map.KEY.ALT_SHIFT_J,
    options = options,
  }
  map {
    description = 'Duplicate line up',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoNSDUp',
    mode = map.MODE.NORMAL,
    keys = map.KEY.ALT_SHIFT_K,
    options = options,
  }
  map {
    description = 'Duplicate character right',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoNSDRight',
    mode = map.MODE.NORMAL,
    keys = map.KEY.ALT_SHIFT_L,
    options = options,
  }

  -- VISUAL DUPLICATE
  map {
    description = 'Duplicate block left',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoVSDLeft',
    mode = map.MODE.VISUAL,
    keys = map.KEY.ALT_SHIFT_H,
    options = options,
  }
  map {
    description = 'Duplicate block down',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoVSDDown',
    mode = map.MODE.VISUAL,
    keys = map.KEY.ALT_SHIFT_J,
    options = options,
  }
  map {
    description = 'Duplicate block up',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoVSDUp',
    mode = map.MODE.VISUAL,
    keys = map.KEY.ALT_SHIFT_K,
    options = options,
  }
  map {
    description = 'Duplicate block right',
    category = map.CATEGORY.EDITING,
    command = '<Plug>GoVSDRight',
    mode = map.MODE.VISUAL,
    keys = map.KEY.ALT_SHIFT_L,
    options = options,
  }
end)
