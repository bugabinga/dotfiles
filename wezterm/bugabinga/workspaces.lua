local wez = require 'wezterm'
local mux = wez.mux
local win32 = wez.target_triple:find'windows'

local get_my_code_workspace = function()
  if win32 then
    return 'W:'
  else
    return os.getenv 'HOME' .. '/Workspace'
  end
end

local WORKSPACE = get_my_code_workspace()

-- maximize all displayed windows
local maximize_window = function()
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end

local setup_workspaces = function()
  local dork_ws = 'dorkfiles editing'
  local dork_cwd = WORKSPACE .. '/dotfiles'
  local dork_tab, dork_pane, dork_window = mux.spawn_window { cwd = dork_cwd, workspace = dork_ws }
  local dork_top_pane = dork_pane:split { cwd = dork_cwd, direction = 'Top', size = 0.42 }
  dork_top_pane:split { cwd = dork_cwd, direction = 'Left', size = 0.69 }
  dork_tab:set_title 'Dorkfiles Editing'
  local wezterm_config_tab = dork_window:spawn_tab { cwd = dork_cwd .. '/wezterm' }
  wezterm_config_tab:set_title 'Wezterm'
  wezterm_config_tab:active_pane():split { cwd = dork_cwd .. '/wezterm', direction = 'Left', size = 0.69 }
  local helix_config_tab = dork_window:spawn_tab { cwd = dork_cwd .. '/neovim' }
  helix_config_tab:set_title 'Neovim'
  helix_config_tab:active_pane():split { cwd = dork_cwd .. '/neovim', direction = 'Left', size = 0.69 }


  local code_ws = 'code'
  local code_cwd = wez.home_dir
  local code_tab, code_pane, code_window = mux.spawn_window { cwd = code_cwd, workspace = code_ws }
  local code_top_pane = code_pane:split { cwd = code_cwd, direction = 'Top', size = 0.42 }
  code_pane:split { cwd = code_cwd, direction = 'Right', size = 0.42 }
  code_top_pane:split { cwd = code_cwd, direction = 'Right', size = 0.42 }
  code_window:spawn_tab { args = { 'nvim' } }
  code_tab:set_title 'Code'
  code_top_pane:activate()

  local default_ws = 'default'
  local default_cwd = wez.home_dir
  local default_tab, default_pane, default_window = mux.spawn_window { cwd = default_cwd, workspace = default_ws }
  local default_top_pane = default_pane:split { cwd = default_cwd, direction = 'Top', size = 0.42 }
  default_pane:split { cwd = default_cwd, direction = 'Right', size = 0.42 }
  default_top_pane:split { cwd = default_cwd, direction = 'Right', size = 0.42 }
  default_window:spawn_tab { args = { 'btm' } }
  default_tab:set_title 'Default'
  default_top_pane:activate()

  mux.set_active_workspace(default_ws)
end

wez.on('gui-attached', function()
  maximize_window()
end)

-- NOTE(oli): errors in here do not show up as configuration errors
-- check the log file in the wezterm mux server runtime directory
-- e.g. /run/user/1000/wezterm/log
wez.on('mux-startup', function()
  setup_workspaces()
end)
