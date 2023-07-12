-- asserts if given value is of given types
return function(value, function_name, parameter_name, ...)
  assert(
    type(function_name) == 'string',
    'the parameter function_name to function check_parameter cannot be nil and must be string'
  )
  assert(
    type(parameter_name) == 'string',
    'the parameter parameter_name to function check_parameter cannot be nil and must be string'
  )

  local prelude = 'the parameter ' .. parameter_name .. ' to function ' .. function_name

  assert(value, prelude .. ' cannot be nil!')

  local actual_type = type(value)
  local type_check = false

  local arg = { ... } -- we are still lua version 5.1 in here...
  -- if no types are given, we pass
  if vim.tbl_isempty(arg) then
    return value
  end

  for _, expected_type in ipairs(arg) do
    local same_type = actual_type == expected_type
    type_check = type_check or same_type
  end

  assert(type_check, prelude .. ' must be one of ' .. vim.inspect(arg) .. ', but is ' .. actual_type .. '.')

  return value
end
