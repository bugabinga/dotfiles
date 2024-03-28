local light_up = require 'std.light_up'

local light_up_current_buffer = function ()
  local group_names = light_up.get_vim_highlight_groups()
  light_up.buffer( 0, group_names )
end

vim.api.nvim_create_user_command(
  'LightUp',
  light_up_current_buffer,
  {}
)
