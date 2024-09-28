local wez = require 'wezterm'

local custom_action = function ( _ )
  local id = 'custom-action-' .. tostring( wez.time.now() )
  wez.on( id, _ )
  return wez.action.EmitEvent( id )
end

local leader = { key = 'VoidSymbol', }
if wez.target_triple:find 'windows' then
  leader = { key = 'raw:255', }
end
local font_size_mode = ' Change Font Size (=-+)'
local pane_mode = ' Pane (hjklqr)'
local resize_pane_mode = 'ﭕ Resize Pane (hjkl)'

local key_tables = {
  [resize_pane_mode] = {
    { key = 'h',      action = wez.action.AdjustPaneSize { 'Left', 1, }, },
    { key = 'j',      action = wez.action.AdjustPaneSize { 'Down', 1, }, },
    { key = 'k',      action = wez.action.AdjustPaneSize { 'Up', 1, }, },
    { key = 'l',      action = wez.action.AdjustPaneSize { 'Right', 1, }, },

    -- Cancel the mode
    { key = 'Escape', action = 'PopKeyTable', },
  },
  [font_size_mode] = {
    { key = '-',      action = wez.action.DecreaseFontSize, },
    { key = '=',      action = wez.action.IncreaseFontSize, },
    { key = '0',      action = wez.action.ResetFontSize, },

    { key = 'Escape', action = 'PopKeyTable', },
  },
  [pane_mode] = {
    { key = 'h',      action = wez.action.ActivatePaneDirection 'Left', },
    { key = 'j',      action = wez.action.ActivatePaneDirection 'Down', },
    { key = 'k',      action = wez.action.ActivatePaneDirection 'Up', },
    { key = 'l',      action = wez.action.ActivatePaneDirection 'Right', },
    { key = 'a',      action = wez.action.PaneSelect, },

    { key = 'v',      action = wez.action.SplitHorizontal { domain = 'CurrentPaneDomain', }, },
    { key = 's',      action = wez.action.SplitVertical { domain = 'CurrentPaneDomain', }, },

    { key = '=',      action = wez.action.ActivateKeyTable { name = resize_pane_mode, one_shot = false, }, },

    { key = 'q',      action = wez.action.CloseCurrentPane { confirm = false, }, },

    { key = 'Escape', action = 'PopKeyTable', },
  },
}

local keys = {
  {
    key = '0',
    mods = 'LEADER',
    action = wez.action.ActivateKeyTable { name = font_size_mode, one_shot = false, },
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wez.action.ActivateKeyTable { name = pane_mode, },
  },
  {
    key = 'f',
    mods = 'LEADER',
    action = wez.action.TogglePaneZoomState,
  },
  {
    key = 'F5',
    mods = 'LEADER',
    action = wez.action.ReloadConfiguration,
  },
  {
    key = 'F11',
    mods = 'LEADER',
    action = wez.action.ToggleFullScreen,
  },
  {
    key = 'F12',
    mods = 'LEADER',
    action = wez.action.ShowDebugOverlay,
  },
  {
    key = '.',
    mods = 'LEADER',
    action = wez.action.CharSelect {
      copy_on_select = true,
      copy_to = 'ClipboardAndPrimarySelection',
    },
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = wez.action.PromptInputLine {
      description = wez.format {
        { Attribute = { Intensity = 'Bold', }, },
        { Foreground = { AnsiColor = 'Purple', }, },
        { Text = 'New workspace:', },
      },
      action = wez.action_callback( function ( window, pane, line )
        if line then
          window:perform_action(
            wez.action.SwitchToWorkspace { name = line, },
            pane
          )
        end
      end ),
    },
  },
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
  {
    key = 't',
    mods = 'LEADER',
    action = wez.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = wez.action.ShowLauncherArgs {
      title = '🔭 Launcher',
      flags = 'FUZZY|DOMAINS|KEY_ASSIGNMENTS|COMMANDS',
    },
  },
  {
    key = 'Tab',
    mods = 'LEADER',
    action = wez.action.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
  {
    key = 'd',
    mods = 'LEADER',
    action = wez.action.ShowLauncherArgs {
      title = '󰮫 Menu',
      flags = 'FUZZY|LAUNCH_MENU_ITEMS',
    },
  },
  {
    key = '/',
    mods = 'LEADER',
    action = wez.action.Search 'CurrentSelectionOrEmptyString',
  },
  {
    key = 'Enter',
    mods = 'LEADER',
    action = wez.action.QuickSelect,
  },
  {
    key = 'q',
    mods = 'LEADER',
    action = wez.action.QuitApplication,
  },
  {
    key = 'm',
    mods = 'LEADER',
    action = custom_action( function ( window, pane )
      local unix_domain = 'unix'
      wez.log_info( 'Current pane domain name: ', pane:get_domain_name() )
      if pane:get_domain_name() == unix_domain then
        wez.log_info( 'Detaching from: ', unix_domain )
        window:perform_action( wez.action.DetachDomain { DomainName = unix_domain, }, pane )
      else
        wez.log_info( 'Switching to: ', unix_domain )
        window:perform_action( wez.action.AttachDomain( unix_domain ), pane )
      end
    end ),
  },
}

-- Navigate Tabs by LEADER+n
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert( keys, {
    key = tostring( i ),
    mods = 'LEADER',
    action = wez.action.ActivateTab( i - 1 ),
  } )
end

return function ( cfg )
  cfg.disable_default_key_bindings = true
  cfg.leader = leader
  cfg.keys = keys
  cfg.key_tables = key_tables
end
