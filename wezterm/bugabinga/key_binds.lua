local wez = require 'wezterm'
local leader = { key = 'VoidSymbol'}
if wez.target_triple:find'windows' then 
  leader = { key = 'raw:255'}
end
local resize_pane_mode = 'ﭕ Resize Pane Mode'
local font_size_mode = ' Change Font Size Mode'

local keys = {
  -- Modes
  {
    key = 'r',
    mods = 'LEADER',
    action = wez.action.ActivateKeyTable {
      name = resize_pane_mode,
      one_shot = false,
    },
  },
  {
    key = 'a',
    mods = 'LEADER',
    action = wez.action.PaneSelect,
  },
  {
    key = 'f',
    mods = 'LEADER',
    action = wez.action.TogglePaneZoomState,
  },
  -- global actions
  {
    key = 'F2',
    action = wez.action.SwitchWorkspaceRelative(-1),
  },
  {
    key = 'F3',
    action = wez.action.SwitchWorkspaceRelative(1),
  },
  {
    key = 'F5',
    action = wez.action.ReloadConfiguration,
  },
  {
    key = 'F11',
    action = wez.action.ToggleFullScreen,
  },
  {
    key = 'F12',
    action = wez.action.ShowDebugOverlay,
  },
  -- change font size
  {
    key = '0',
    mods = 'LEADER',
    action = wez.action.ActivateKeyTable {
      name = font_size_mode,
      one_shot = false,
    },
  },
  -- open unicode/emoji picker
  {
    key = 'u',
    mods = 'LEADER',
    action = wez.action.CharSelect {
      copy_on_select = true,
      copy_to = 'ClipboardAndPrimarySelection'
    },
  },
  -- Copy and Paste
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wez.action.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wez.action.PasteFrom 'Clipboard',
  },
  -- Splitting Panes
  {
    key = 'v',
    mods = 'LEADER',
    action = wez.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = wez.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Tabs
  {
    key = 't',
    mods = 'LEADER',
    action = wez.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wez.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'Tab',
    mods = 'LEADER|CTRL',
    action = wez.action.ActivateTabRelative(1),
  },
  {
    key = 'Tab',
    mods = 'LEADER|SHIFT',
    action = wez.action.ActivateTabRelative(-1),
  },
  -- Search all Actions
  {
    key = 'p',
    mods = 'LEADER',
    action = wez.action.ActivateCommandPalette,
  },
  -- Quit
  {
    key = 'q',
    mods = 'LEADER',
    action = wez.action.QuitApplication,
  },
}
-- Navigate Tabs by LEADER+n
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wez.action.ActivateTab(i - 1),
  })
end

local key_tables = {
  [resize_pane_mode] = {
    { key = 'LeftArrow',  action = wez.action.AdjustPaneSize { 'Left', 1 } },
    { key = 'h',          action = wez.action.AdjustPaneSize { 'Left', 1 } },

    { key = 'RightArrow', action = wez.action.AdjustPaneSize { 'Right', 1 } },
    { key = 'l',          action = wez.action.AdjustPaneSize { 'Right', 1 } },

    { key = 'UpArrow',    action = wez.action.AdjustPaneSize { 'Up', 1 } },
    { key = 'k',          action = wez.action.AdjustPaneSize { 'Up', 1 } },

    { key = 'DownArrow',  action = wez.action.AdjustPaneSize { 'Down', 1 } },
    { key = 'j',          action = wez.action.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode
    { key = 'Escape',     action = 'PopKeyTable' },
    { key = 'Enter',      action = 'PopKeyTable' },
  },
  [font_size_mode] = {
    { key = '+',      action = wez.action.IncreaseFontSize },
    { key = '-',      action = wez.action.DecreaseFontSize },
    { key = '=',      action = wez.action.ResetFontSize },

    { key = 'Escape', action = 'PopKeyTable' },
  },
}

return {
  leader = leader,
  keys = keys,
  key_tables = key_tables,
}
