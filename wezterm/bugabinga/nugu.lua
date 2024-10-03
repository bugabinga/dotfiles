return {
    ['nugu-dark'] = {
    -- The default text color
    foreground = '#fcfcfc',
    -- The default background color
    background = '#000000',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#3a003a',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#000000',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#3a003a',

    selection_fg = '#000000',
    selection_bg = '#2dacc8',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#1d5a69',

    -- The color of the split lines between panes
    split = '#1d5a69',

    ansi = {
      '#020202', -- black
      '#bd1c54', -- red
      '#7d9cc5', -- green
      '#c79e6e', -- yellow
      '#5e45c5', -- blue
      '#5d005d', -- magenta
      '#2eb3d1', -- cyan
      '#fafafa', -- white
    },

    brights = {
      '#050505',
      '#b6285a',
      '#8aa0bd',
      '#bf9f7b',
      '#6955ba',
      '#5d055d',
      '#3fadc5',
      '#fcfcfc',
    },

    compose_cursor = '#2dacc8',
    visual_bell = '#593fc2',
  },
    ['nugu-light'] = {
    -- The default text color
    foreground = '#030303',
    -- The default background color
    background = '#ffffff',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#c600c6',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#ffffff',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#c600c6',

    selection_fg = '#ffffff',
    selection_bg = '#0283a3',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#719ba5',

    -- The color of the split lines between panes
    split = '#719ba5',

    ansi = {
      '#fdfdfd', -- black
      '#ce1e5c', -- red
      '#8ba7cb', -- green
      '#cda77c', -- yellow
      '#4a25a9', -- blue
      '#a300a3', -- magenta
      '#017b9a', -- cyan
      '#050505', -- white
    },

    brights = {
      '#fafafa',
      '#be295d',
      '#90a5c1',
      '#c2a482',
      '#4d2e9b',
      '#960896',
      '#08738d',
      '#030303',
    },

    compose_cursor = '#0283a3',
    visual_bell = '#4e28b0',
  },
  }