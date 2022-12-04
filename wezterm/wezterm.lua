local wez = require 'wezterm'
local nugu = require 'bugabinga.nugu'

local color_scheme = 'nugu-dark' -- not there yet ;)
local color_schemes = nugu

local hostname = wez.hostname()
local enable_wayland = false
local window_decorations = 'RESIZE'
local font_size = 11.0
local font = wez.font 'IBM Plex Mono'

if hostname == 'x230' then
  enable_wayland = true
  window_decorations = 'NONE'
elseif hostname == 'pop-os' then
  font_size = 12
elseif hostname == 'PC-00625' then
  font_size = 14
  font = wez.font 'Cascadia Mono'
  window_decorations = 'TITLE|RESIZE'
end

-- Show which key table is active in the status area
wez.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

local leader = { key = 'Space', mods = 'CTRL|SHIFT', timeout_milliseconds = 1000 }
local keys = {
  -- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
  -- mode until we cancel that mode.
  {
    key = 'r',
    mods = 'LEADER',
    action = wez.action.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },

  -- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
  -- mode until we press some other key or until 1 second (1000ms)
  -- of time elapses
  {
    key = 'a',
    mods = 'LEADER',
    action = wez.action.ActivateKeyTable {
      name = 'activate_pane',
      timeout_milliseconds = 1000,
    },
  },

  -- Copy
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wez.action.CopyTo 'Clipboard',
  },
  -- Paste
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wez.action.PasteFrom 'Clipboard',
  },
  -- Split left-right
  {
    key = 'v',
    mods = 'LEADER',
    action = wez.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Split top-bottom
  {
    key = 'h',
    mods = 'LEADER',
    action = wez.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'q',
    mods = 'LEADER',
    action = wez.action.QuitApplication,
  },
}

local key_tables = {
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name="resize_pane" in
  -- the key assignments above.
  resize_pane = {
    { key = 'LeftArrow', action = wez.action.AdjustPaneSize { 'Left', 1 } },
    { key = 'h', action = wez.action.AdjustPaneSize { 'Left', 1 } },

    { key = 'RightArrow', action = wez.action.AdjustPaneSize { 'Right', 1 } },
    { key = 'l', action = wez.action.AdjustPaneSize { 'Right', 1 } },

    { key = 'UpArrow', action = wez.action.AdjustPaneSize { 'Up', 1 } },
    { key = 'k', action = wez.action.AdjustPaneSize { 'Up', 1 } },

    { key = 'DownArrow', action = wez.action.AdjustPaneSize { 'Down', 1 } },
    { key = 'j', action = wez.action.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape', action = 'PopKeyTable' },
  },

  -- Defines the keys that are active in our activate-pane mode.
  -- 'activate_pane' here corresponds to the name="activate_pane" in
  -- the key assignments above.
  activate_pane = {
    { key = 'LeftArrow', action = wez.action.ActivatePaneDirection 'Left' },
    { key = 'h', action = wez.action.ActivatePaneDirection 'Left' },

    { key = 'RightArrow', action = wez.action.ActivatePaneDirection 'Right' },
    { key = 'l', action = wez.action.ActivatePaneDirection 'Right' },

    { key = 'UpArrow', action = wez.action.ActivatePaneDirection 'Up' },
    { key = 'k', action = wez.action.ActivatePaneDirection 'Up' },

    { key = 'DownArrow', action = wez.action.ActivatePaneDirection 'Down' },
    { key = 'j', action = wez.action.ActivatePaneDirection 'Down' },
  },
}

return {
  font = font,
  font_size = font_size,
  color_scheme = color_scheme,
  color_schemes = color_schemes,
  default_prog = { 'nu' },
  window_decorations = window_decorations,
  enable_tab_bar = true,
  -- if this is hidden, we cannot see the right status area
  hide_tab_bar_if_only_one_tab = false,
  check_for_updates = false,
  show_update_window = false,
  audible_bell = 'Disabled',
  visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = 'CursorColor',
  },
  tab_max_width = 24,
  enable_wayland = enable_wayland,
  window_padding = {
    left = 12,
    right = 8,
    top = 12,
    bottom = 8,
  },
  disable_default_key_bindings = true,
  leader = leader,
  keys = keys,
  key_tables = key_tables,
}
