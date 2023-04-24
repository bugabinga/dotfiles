return {
    ['nugu-dark'] = {
    -- The default text color
    foreground = '#949494',
    -- The default background color
    background = '#272727',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#7e297e',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#907ec2',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#5e5e5e',

    -- the foreground color of selected text
    selection_fg = '#907ec2',
    -- the background color of selected text
    selection_bg = '#516d63',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#232f2b',

    -- The color of the split lines between panes
    split = '#232f2b',

    ansi = {
      '#c9c9c9', -- black
      '#640e23', -- red
      '#4c8093', -- green
      '#917938', -- yellow
      '#9a8bce', -- blue
      '#921592', -- magenta
      '#a3c2af', -- cyan
      '#949494', -- white
    },

    brights = {
      '#e2e2e2',
      '#891d38',
      '#6f95a3',
      '#a99253',
      '#bcb4d7',
      '#b426b4',
      '#c7d1cb',
      '#adadad',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#516d63',
    visual_bell = '#bdb2db',
  },
    ['nugu-light'] = {
    -- The default text color
    foreground = '#949494',
    -- The default background color
    background = '#292929',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#7e297e',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#4e467f',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#5e5e5e',

    -- the foreground color of selected text
    selection_fg = '#4e467f',
    -- the background color of selected text
    selection_bg = '#2f3e39',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#010101',

    -- The color of the split lines between panes
    split = '#010101',

    ansi = {
      '#131313', -- black
      '#640e23', -- red
      '#4c8093', -- green
      '#917938', -- yellow
      '#5f54ab', -- blue
      '#921592', -- magenta
      '#779c86', -- cyan
      '#949494', -- white
    },

    brights = {
      '#2d2d2d',
      '#891d38',
      '#6f95a3',
      '#a99253',
      '#8780b2',
      '#b426b4',
      '#9ea8a2',
      '#adadad',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#2f3e39',
    visual_bell = '#7167ac',
  },
  }