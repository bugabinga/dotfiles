local light_up = require 'std.light_up'
local user_command = require 'std.user_command'

local light_up_current_buffer = function ()
  local group_names = light_up.get_vim_highlight_groups()
  light_up.buffer( 0, group_names )
end

user_command.LightUp
'Highlight hl-group names in current buffer' (
    light_up_current_buffer
  )
