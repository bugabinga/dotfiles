return {
    ['nugu-dark'] = {
    -- The default text color
    foreground = '#cfcfcf',
    -- The default background color
    background = '#131313',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#7a067a',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#5f368d',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#7a067a',

    -- the foreground color of selected text
    selection_fg = '#cfcfcf',
    -- the background color of selected text
    selection_bg = '#4c2b72',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#121212',

    -- The color of the split lines between panes
    split = '#5f368d',

    ansi = {
      '#5d355c',
      '#c41653',
      '#acc1a0',
      '#a08d7b',
      '#6d15c0',
      '#c015c0',
      '#929396',
      '#c7c7c7',
    },

    brights = {
      '#9d9d9d',
      '#ea4571',
      '#a6a78f',
      '#e0cfaa',
      '#8940ea',
      '#ea3fea',
      '#c0d5df',
      '#f2eef1',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#788984',
    -- Colors for copy_mode and quick_select
    -- available since: 20220807-113146-c2fee766
    -- In copy_mode, the color of the active text is:
    -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- 2. selection_* otherwise
    copy_mode_active_highlight_bg = { Color = '#5f368d' },
    copy_mode_active_highlight_fg = { Color = '#cfcfcf' },
    copy_mode_inactive_highlight_bg = { Color = '#121212' },
    copy_mode_inactive_highlight_fg = { Color = '#727272' },

    quick_select_label_bg = { Color = '#5f368d' },
    quick_select_label_fg = { Color = '#cfcfcf' },
    quick_select_match_bg = { Color = '#4c2b72' },
    quick_select_match_fg = { Color = '#cfcfcf' },

    tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- does not apply when fancy tab bar is in use
        background = '#000000',

        -- The active tab is the one that has focus in the window
        active_tab = {
          -- The color of the background area for the tab
          bg_color = '#000000',
          -- The color of the text for the tab
          fg_color = '#5f368d',

          -- Specify whether you want 'Half', 'Normal' or 'Bold' intensity for the
          -- label shown for this tab.
          -- The default is 'Normal'
          intensity = 'Bold',

          -- Specify whether you want 'None', 'Single' or 'Double' underline for
          -- label shown for this tab.
          -- The default is 'None'
          underline = 'Double',

          -- Specify whether you want the text to be italic or not
          -- for this tab.  The default is false.
          italic = false,

          -- Specify whether you want the text to be rendered with strikethrough 
          -- or not for this tab.  The default is false.
          strikethrough = false,
        },

        -- Inactive tabs are the tabs that do not have focus
        inactive_tab = {
          bg_color = '#000000',
          fg_color = '#e2e2e2',
          intensity = 'Normal',

          -- The same options that were listed under the `active_tab` section above
          -- can also be used for `inactive_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over inactive tabs
        inactive_tab_hover = {
          bg_color = '#788984',
          fg_color = '#e2e2e2',
          italic = true,

          -- The same options that were listed under the `active_tab` section above
          -- can also be used for `inactive_tab_hover`.
        },

        -- The new tab button that let you create new tabs
        new_tab = {
          bg_color = '#000000',
          fg_color = '#121212',

          -- The same options that were listed under the `active_tab` section above
          -- can also be used for `new_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over the new tab button
        new_tab_hover = {
          bg_color = '#788984',
          fg_color = '#e2e2e2',
          italic = true,

          -- The same options that were listed under the `active_tab` section above
          -- can also be used for `new_tab_hover`.
        },
      },
  },
    ['nugu-light'] = {
    -- The default text color
    foreground = '#494949',
    -- The default background color
    background = '#e3e3e3',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#d43dd4',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#9170b5',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#d43dd4',

    -- the foreground color of selected text
    selection_fg = '#494949',
    -- the background color of selected text
    selection_bg = '#ae95c8',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '#c9c9c9',

    -- The color of the split lines between panes
    split = '#9170b5',

    ansi = {
      '#060406',
      '#4a081f',
      '#668355',
      '#55493d',
      '#280845',
      '#450845',
      '#4e4f51',
      '#838383',
    },

    brights = {
      '#595959',
      '#961134',
      '#60624c',
      '#bb9647',
      '#481091',
      '#901090',
      '#6599b1',
      '#b6a1b4',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#646464',
    -- Colors for copy_mode and quick_select
    -- available since: 20220807-113146-c2fee766
    -- In copy_mode, the color of the active text is:
    -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- 2. selection_* otherwise
    copy_mode_active_highlight_bg = { Color = '#9170b5' },
    copy_mode_active_highlight_fg = { Color = '#494949' },
    copy_mode_inactive_highlight_bg = { Color = '#c9c9c9' },
    copy_mode_inactive_highlight_fg = { Color = '#878787' },

    quick_select_label_bg = { Color = '#9170b5' },
    quick_select_label_fg = { Color = '#494949' },
    quick_select_match_bg = { Color = '#ae95c8' },
    quick_select_match_fg = { Color = '#494949' },

    tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- does not apply when fancy tab bar is in use
        background = '#c7c7c7',

        -- The active tab is the one that has focus in the window
        active_tab = {
          -- The color of the background area for the tab
          bg_color = '#c7c7c7',
          -- The color of the text for the tab
          fg_color = '#9170b5',

          -- Specify whether you want 'Half', 'Normal' or 'Bold' intensity for the
          -- label shown for this tab.
          -- The default is 'Normal'
          intensity = 'Bold',

          -- Specify whether you want 'None', 'Single' or 'Double' underline for
          -- label shown for this tab.
          -- The default is 'None'
          underline = 'Double',

          -- Specify whether you want the text to be italic or not
          -- for this tab.  The default is false.
          italic = false,

          -- Specify whether you want the text to be rendered with strikethrough 
          -- or not for this tab.  The default is false.
          strikethrough = false,
        },

        -- Inactive tabs are the tabs that do not have focus
        inactive_tab = {
          bg_color = '#c7c7c7',
          fg_color = '#929292',
          intensity = 'Normal',

          -- The same options that were listed under the `active_tab` section above
          -- can also be used for `inactive_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over inactive tabs
        inactive_tab_hover = {
          bg_color = '#646464',
          fg_color = '#929292',
          italic = true,

          -- The same options that were listed under the `active_tab` section above
          -- can also be used for `inactive_tab_hover`.
        },

        -- The new tab button that let you create new tabs
        new_tab = {
          bg_color = '#c7c7c7',
          fg_color = '#c9c9c9',

          -- The same options that were listed under the `active_tab` section above
          -- can also be used for `new_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over the new tab button
        new_tab_hover = {
          bg_color = '#646464',
          fg_color = '#929292',
          italic = true,

          -- The same options that were listed under the `active_tab` section above
          -- can also be used for `new_tab_hover`.
        },
      },
  },
  }