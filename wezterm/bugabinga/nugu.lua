return {
    ['nugu-dark'] = {
    -- The default text color
    foreground = '#ffffff',
    -- The default background color
    background = '#000000',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#2f042f',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#4c3d87',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#2f042f',

    -- the foreground color of selected text
    selection_fg = '#4c3d87',
    -- the background color of selected text
    selection_bg = '#2e7585',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#053843',

    -- The color of the split lines between panes
    split = '#053843',

    ansi = {
      '#ececec', -- black
      '#9e1e4b', -- red
      '#708eb5', -- green
      '#b88f60', -- yellow
      '#5540ab', -- blue
      '#560356', -- magenta
      '#3093aa', -- cyan
      '#676767', -- white
    },

    brights = {
      '#ffffff',
      '#bd3263',
      '#9aaabe',
      '#bfa78c',
      '#7767b7',
      '#810c81',
      '#4faabe',
      '#818181',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#2e7585',
    visual_bell = '#4c3d87',
  },
    ['nugu-light'] = {
    -- The default text color
    foreground = '#ececec',
    -- The default background color
    background = '#131313',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#bd0fbd',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#9e92cf',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#bd0fbd',

    -- the foreground color of selected text
    selection_fg = '#9e92cf',
    -- the background color of selected text
    selection_bg = '#85c6d6',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#11a1c5',

    -- The color of the split lines between panes
    split = '#11a1c5',

    ansi = {
      '#ffffff', -- black
      '#d8326c', -- red
      '#a3b6cf', -- green
      '#d0b596', -- yellow
      '#8270ca', -- blue
      '#a006a0', -- magenta
      '#60bdd4', -- cyan
      '#8d8d8d', -- white
    },

    brights = {
      '#e6e6e6',
      '#aa2d59',
      '#8b9db4',
      '#b69b7d',
      '#6957b0',
      '#690a69',
      '#45a4bc',
      '#747474',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#85c6d6',
    visual_bell = '#9e92cf',
  },
  }