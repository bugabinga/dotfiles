return {
    ['nugu-dark'] = {
    -- The default text color
    foreground = '#e2e2e2',
    -- The default background color
    background = '#000000',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#1e011e',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#5f368d',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#1e011e',

    -- the foreground color of selected text
    selection_fg = '#4c2b72',
    -- the background color of selected text
    selection_bg = '#788984',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#121212',

    -- The color of the split lines between panes
    split = '#121212',

    ansi = {
      '#cfcfcf', -- black
      '#740523', -- red
      '#4187a7', -- green
      '#a7802d', -- yellow
      '#7a3bc3', -- blue
      '#800080', -- magenta
      '#a5bdb6', -- cyan
      '#727272', -- white
    },

    brights = {
      '#e9e9e9',
      '#9c1035',
      '#679cb4',
      '#be9949',
      '#966cc5',
      '#aa09aa',
      '#c8cdcc',
      '#8b8b8b',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#788984',
    visual_bell = '#5f368d',
  },
    ['nugu-light'] = {
    -- The default text color
    foreground = '#000000',
    -- The default background color
    background = '#dadada',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#7c047c',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#551991',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#7c047c',

    -- the foreground color of selected text
    selection_fg = '#1d0931',
    -- the background color of selected text
    selection_bg = '#3a3b3b',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#3a3b3b',

    -- The color of the split lines between panes
    split = '#3a3b3b',

    ansi = {
      '#131313', -- black
      '#67031e', -- red
      '#3a7f9f', -- green
      '#9e7827', -- yellow
      '#1d0733', -- blue
      '#800080', -- magenta
      '#373f3c', -- cyan
      '#6b6b6b', -- white
    },

    brights = {
      '#000000',
      '#330411',
      '#355e71',
      '#6e5624',
      '#040106',
      '#490449',
      '#212121',
      '#525252',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#3a3b3b',
    visual_bell = '#551991',
  },
  }