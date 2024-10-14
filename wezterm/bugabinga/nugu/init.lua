local nugu_dark = require 'bugabinga/nugu/palette_dark'
local nugu_light = require 'bugabinga/nugu/palette_light'

local make_theme = function ( palette )
  return {
    -- The default text color
    foreground = palette.ui.normal,
    -- The default background color
    background = palette.ui.backdrop,
    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = palette.ui.accent,
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = palette.ui.backdrop,
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = palette.ui.accent,
    selection_fg = palette.ui.backdrop,
    selection_bg = palette.ui.focus,
    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = palette.ui.unfocus,
    -- The color of the split lines between panes
    split = palette.ui.unfocus,
    ansi = {
      palette.content.backdrop,         -- black
      palette.error,                    -- maroon
      palette.content.focus,            -- green
      palette.warning,                  -- olive
      palette.content.important_local,  -- navy
      palette.content.important_global, -- purple
      palette.info,                     -- teal
      palette.content.minor,            -- silver
    },
    brights = {
      palette.content.minor,   -- grey
      palette.error,           -- red
      palette.content.accent,  -- lime
      palette.warning,         -- yellow
      palette.content.unfocus, -- blue
      palette.debug,           -- fuchsia
      palette.content.focus,   -- aqua
      palette.content.normal,  -- white
    },
    -- Arbitrary colors of the palette in the range from 16 to 255
    indexed = {},
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = palette.ui.focus,
    -- Colors for copy_mode and quick_select
    -- available since: 20220807-113146-c2fee766
    -- In copy_mode, the color of the active text is:
    -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- 2. selection_* otherwise
    copy_mode_active_highlight_bg = { Color = palette.ui.accent, },
    copy_mode_active_highlight_fg = { Color = palette.ui.backdrop, },
    copy_mode_inactive_highlight_bg = { Color = palette.ui.unfocus, },
    copy_mode_inactive_highlight_fg = { Color = palette.ui.normal, },
    quick_select_label_bg = { Color = palette.ui.minor, },
    quick_select_label_fg = { Color = palette.ui.normal, },
    quick_select_match_bg = { Color = palette.ui.unfocus, },
    quick_select_match_fg = { Color = palette.ui.normal, },
    tab_bar = {
      -- The color of the strip that goes along the top of the window
      -- (does not apply when fancy tab bar is in use)
      background = palette.ui.backdrop,

      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = palette.ui.backdrop,
        -- The color of the text for the tab
        fg_color = palette.ui.normal,

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = 'Bold',

        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = 'Double',

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = palette.ui.backdrop,
        fg_color = palette.ui.normal,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = palette.ui.focus,
        fg_color = palette.ui.normal,
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = palette.ui.backdrop,
        fg_color = palette.ui.normal,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = palette.ui.focus,
        fg_color = palette.ui.normal,
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
      },
    },
  }
end

return {
  ['nugu-dark'] = make_theme( nugu_dark.palette ),
  ['nugu-light'] = make_theme( nugu_light.palette ),
}
