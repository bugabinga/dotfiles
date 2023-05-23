local wez = require 'wezterm'
local mux = wez.mux


local get_my_code_workspace = function()
  if wez.target_triple:find('windows') then
    return 'W:'
  else
    return os.getenv 'HOME' .. '/Workspace'
  end
end

local WORKSPACE = get_my_code_workspace()

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
  local nugu_ws = 'nugu development'
  local nugu_cwd = WORKSPACE .. '/nugu'
  local nugu_tab, nugu_pane, nugu_window = mux.spawn_window { cwd = nugu_cwd, workspace = nugu_ws }
  local nugu_top_pane = nugu_pane:split { cwd = nugu_cwd, args = { 'hx', '.' }, direction = 'Top', size = 0.82 }
  nugu_top_pane:split { cwd = nugu_cwd, direction = 'Left', size = 0.66 }
  nugu_tab:set_title 'Nugu Development'


  local tini_lang_ws = 'tini_lang development'
  local tini_lang_cwd = WORKSPACE .. '/tini_lang'
  local tini_lang_tab, tini_lang_pane, tini_lang_window = mux.spawn_window { cwd = tini_lang_cwd, workspace =
      tini_lang_ws }
  local tini_lang_top_pane = tini_lang_pane:split { cwd = tini_lang_cwd, args = { 'hx', '.' }, direction = 'Top', size = 0.82 }
  tini_lang_top_pane:split { cwd = tini_lang_cwd, direction = 'Left', size = 0.66 }
  tini_lang_tab:set_title 'tini_lang Development'


  local reign_ws = 'reign development'
  local reign_cwd = WORKSPACE .. '/reign'
  local reign_tab, reign_pane, reign_window = mux.spawn_window { cwd = reign_cwd, args = { 'hx', '.' }, workspace =
      reign_ws }
  local reign_right_pane = reign_pane:split { cwd = reign_cwd, direction = 'Right', size = 0.36 }
  reign_right_pane:split { cwd = reign_cwd, direction = 'Bottom', size = 0.33 }
  reign_tab:set_title 'Reign Development'
  reign_pane:activate()
  -- FIXME(oli): the text gets send, but seemingly before nushell is ready to receive input
  reign_right_pane:send_text 'watch src {clear; just build}'


  local dork_ws = 'dorkfiles editing'
  local dork_cwd = WORKSPACE .. '/dotfiles'
  local dork_tab, dork_pane, dork_window = mux.spawn_window { cwd = dork_cwd, workspace = dork_ws }
  local dork_top_pane = dork_pane:split { direction = 'Top', size = 0.55 }
  dork_top_pane:split { cwd = dork_cwd, args = { 'hx', '.' }, direction = 'Left', size = 0.7 }
  dork_tab:set_title 'Dorkfiles Editing'
  --TODO(oli): create tabs for configs in dorkfiles that i edit often (wezterm, helix, bootstripper,...)
  local wezterm_config_tab = dork_window:spawn_tab { cwd = dork_cwd .. '/wezterm' }
  wezterm_config_tab:set_title 'Wezterm'
  wezterm_config_tab:active_pane():split { args = { 'hx', '.' }, direction = 'Left', size = 0.7 }
  local helix_config_tab = dork_window:spawn_tab { cwd = dork_cwd .. '/helix' }
  helix_config_tab:set_title 'Helix'
  helix_config_tab:active_pane():split { args = { 'hx', '.' }, direction = 'Left', size = 0.7 }


  local default_ws = 'default'
  local default_tab, default_pane, default_window = mux.spawn_window { workspace = default_ws }
  local default_top_pane = default_pane:split { direction = 'Top', size = 0.5 }
  default_pane:split { direction = 'Right', size = 0.5 }
  default_top_pane:split { direction = 'Right', size = 0.5 }
  default_window:spawn_tab { args = { 'btm' } }
  default_tab:set_title 'Default'
  default_top_pane:activate()

  mux.set_active_workspace(default_ws)
end)
