local icon = require'std.icon'
local table = require'std.table'

local function display(value)
  if value == nil then
    return 'nil', 'Special'
  end

  local value_type = type(value)

  if value_type == 'string' then
    return icon.quot_left .. ' ' .. value .. ' ' .. icon.quot_right, 'String'
  end

  if value_type == 'number' then
    return icon.hash .. ' ' .. tostring(value), 'Number'
  end

  if value_type == 'boolean' then
    local mark = value and icon.checkbox_mark or icon.checkbox_unmark
    return mark, 'Boolean'
  end

  if value_type == 'userdata' then
    local ud = icon.user .. icon.data
    return ud .. ' ' .. tostring(value), 'Identifier'
  end

  if value_type == 'thread' then
    local thread = icon.thread
    return thread .. ' ' .. tostring(value), 'Identifier'
  end

  if value_type == 'function' then
    local fn = icon['function']
    return fn .. ' ' .. tostring(value), 'Function'
  end

  if value_type == 'table' then
    return table.deep_concat(value, {render_value = display}), 'Identifier'
  end
end

return display
