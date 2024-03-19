local wez = require 'wezterm'
local leader = { key = 'VoidSymbol' }
if wez.target_triple:find 'windows' then
	leader = { key = 'raw:255' }
end
local font_size_mode = ' Change Font Size (=-+)'
local pane_mode = ' Pane (hjklqr)'
local resize_pane_mode = 'ﭕ Resize Pane (hjkl)'
local bracketed_mode = ' Navigate to...'
local navigate_forward_mode = ' Navigate forward ...'
local navigate_backward_mode = ' Navigate backward ...'

local key_tables = {
	[resize_pane_mode] = {
		{ key = 'h',      action = wez.action.AdjustPaneSize { 'Left', 1 } },
		{ key = 'j',      action = wez.action.AdjustPaneSize { 'Down', 1 } },
		{ key = 'k',      action = wez.action.AdjustPaneSize { 'Up', 1 } },
		{ key = 'l',      action = wez.action.AdjustPaneSize { 'Right', 1 } },

		-- Cancel the mode
		{ key = 'Escape', action = 'PopKeyTable' },
	},
	[font_size_mode] = {
		{ key = '+',      action = wez.action.IncreaseFontSize },
		{ key = '-',      action = wez.action.DecreaseFontSize },
		{ key = '=',      action = wez.action.ResetFontSize },

		{ key = 'Escape', action = 'PopKeyTable' },
	},
	[pane_mode] = {
		{ key = 'h',      action = wez.action.ActivatePaneDirection 'Left' },
		{ key = 'j',      action = wez.action.ActivatePaneDirection 'Down' },
		{ key = 'k',      action = wez.action.ActivatePaneDirection 'Up' },
		{ key = 'l',      action = wez.action.ActivatePaneDirection 'Right' },

		{ key = 'v', action = wez.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
		{ key = 's', action = wez.action.SplitVertical { domain = 'CurrentPaneDomain' }, },

		{ key = 'r',      action = wez.action.ActivateKeyTable { name = resize_pane_mode, one_shot = false } },

		{ key = 'q',      action = wez.action.CloseCurrentPane { confirm = true } },

		{ key = 'Escape', action = 'PopKeyTable' },
	},
	[bracketed_mode] = {
	},
	[navigate_forward_mode] = {
		{
			key = 'b', -- b as in buffer in vim
			action = wez.action.ActivateTabRelative(1),
		},
	},
	[navigate_backward_mode] = {
		{
			key = 'b',
			action = wez.action.ActivateTabRelative(-1),
		},
	}
}

local keys = {
	{
		key = ']',
		mods = 'LEADER',
		action = wez.action.ActivateKeyTable { name = navigate_forward_mode },
	},
	{
		key = '[',
		mods = 'LEADER',
		action = wez.action.ActivateKeyTable { name = navigate_backward_mode },
	},
	{
		key = '0',
		mods = 'LEADER',
		action = wez.action.ActivateKeyTable { name = font_size_mode, one_shot = false },
	},
	{
		key = 'w',
		mods = 'LEADER',
		action = wez.action.ActivateKeyTable { name = pane_mode },
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
		key = 'u',
		mods = 'LEADER',
		action = wez.action.CharSelect {
			copy_on_select = true,
			copy_to = 'ClipboardAndPrimarySelection'
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
		action = wez.action.ActivateCommandPalette,
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



return {
	leader = leader,
	keys = keys,
	key_tables = key_tables,
}
