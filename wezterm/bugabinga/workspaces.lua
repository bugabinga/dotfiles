local wez = require 'wezterm'
local mux = wez.mux

local default_ws = 'default'
local nugu_ws = 'nugu development'
local reign_ws = 'reign development'
local dork_ws = 'dorkfiles editing'

local HOME = os.getenv 'HOME'
local WORKSPACE = HOME .. '/Workspace'

wez.on('gui-attached', function()
  -- maximize all displayed windows on startup
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)

-- NOTE(oli): errors in here do not show up as configuration errors
-- check the log file in the wezterm mux server runtime directory
-- e.g. /run/user/1000/wezterm/log
wez.on('mux-startup', function()
  local nugu_tab, nugu_pane, nugu_window = mux.spawn_window { cwd = WORKSPACE .. '/nugu', workspace = nugu_ws }
  local nugu_top_pane = nugu_pane:split { args = { 'hx', '.' }, direction = 'Top', size = 0.82 }
  nugu_top_pane:split { direction = 'Left', size = 0.66 }
  nugu_tab:set_title 'Nugu Development'

  local reign_tab, reign_pane, reign_window = mux.spawn_window { args = { 'hx', '.' }, cwd = WORKSPACE .. '/reign', workspace =
      reign_ws }
  local reign_right_pane = reign_pane:split { direction = 'Right', size = 0.36 }
  reign_right_pane:split { direction = 'Bottom', size = 0.33 }
  reign_tab:set_title 'Reign Development'
  reign_right_pane:send_text 'watch src {clear; just build}\n'
  reign_pane:activate()

  local dork_tab, dork_pane, dork_window = mux.spawn_window { cwd = WORKSPACE .. '/dotfiles', workspace = dork_ws }
  local dork_top_pane = dork_pane:split { direction = 'Top', size = 0.55 }
  dork_top_pane:split { args = { 'hx', '.' }, direction = 'Left', size = 0.7 }
  dork_tab:set_title 'Dorkfiles Editing'
  --TODO(oli): create tabs for configs in dorkfiles that i edit often (wezterm, helix, bootstripper,...)

  local default_tab, default_pane, default_window = mux.spawn_window { workspace = default_ws }
  local default_top_pane = default_pane:split { direction = 'Top', size = 0.5 }
  default_pane:split { direction = 'Right', size = 0.5 }
  default_top_pane:split { direction = 'Right', size = 0.5 }
  default_window:spawn_tab { args = { 'btm' } }
  default_tab:set_title 'Default'
  default_top_pane:activate()

  mux.set_active_workspace(default_ws)
end)
