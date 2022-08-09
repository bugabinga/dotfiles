return {
  ['nugu-dark'] = {
    -- The default text color
    foreground = '#c9c9c9',
    -- The default background color
    background = '#131313',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#814eaa',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#e0e0e0',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#8BABA5',

    -- the foreground color of selected text
    selection_fg = '#fefefe',
    -- the background color of selected text
    selection_bg = '#8BABA5',

    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = '#287F70',

    -- The color of the split lines between panes
    split = '#287F70',

    ansi = {
      '#113131', -- black
      '#A21300', -- red
      '#56968C', -- green
      '#A2A213', -- yellow
      '#2F77AE', -- blue
      '#992FAE', -- magenta
      '#13A2A2', -- cyan
      '#31ae99', -- white
    },

    brights = {
      '#638787',
      '#e17769',
      '#cacaca',
      '#d4d48a',
      '#b4c5d1',
      '#ccb4d1',
      '#8ad4d4',
      '#b6d1cd',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#2F77AE',
    visual_bell = '#A21300',
  },
  ['nugu-light'] = {
    -- The default text color
    foreground = '#131313',
    -- The default background color
    background = '#c9c9c9',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#814eaa',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#e0e0e0',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#8BABA5',

    -- the foreground color of selected text
    selection_fg = '#fefefe',
    -- the background color of selected text
    selection_bg = '#8BABA5',

    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = '#287F70',

    -- The color of the split lines between panes
    split = '#287F70',

    ansi = {
      '#113131', -- black
      '#A21300', -- red
      '#56968C', -- green
      '#A2A213', -- yellow
      '#2F77AE', -- blue
      '#992FAE', -- magenta
      '#13A2A2', -- cyan
      '#31ae99', -- white
    },

    brights = {
      '#638787',
      '#e17769',
      '#cacaca',
      '#d4d48a',
      '#b4c5d1',
      '#ccb4d1',
      '#8ad4d4',
      '#b6d1cd',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#2F77AE',
    visual_bell = '#A21300',
  },
}
