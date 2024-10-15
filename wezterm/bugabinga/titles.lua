local wez = require 'wezterm'

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename( s )
  return string.gsub( s, '(.*[/\\])(.*)', '%2' )
end

local function tab_title( tab )
  local title = tab.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  local pane = tab.active_pane
  title = basename( pane.foreground_process_name )
  local index = tab.tab_index + 1
  return '・' .. index .. ' ' .. title .. ' '
end

return function ( _ )
  wez.on(
    'format-tab-title',
    function ( tab ) return tab_title( tab ) end
  )
end
