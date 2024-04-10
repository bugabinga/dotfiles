local debug = require 'std.dbg'

--- loads given lua file path in current working directory into the current neovim lua runtime.
--- @param file_name string path to lua file, that should be loaded
--- @param validator function|string|table a validation function, that checks, if the loaded value fulfills your requirements.
--- If `validator` is a string or table, then it should contain the allowed types of the value.
--- @return any returns the evaluated value of the loaded lua file or `nil`, if it does not exists or did not pass
--- validation.
return function ( file_name, validator )
  local filepath = vim.fn.fnamemodify( file_name, ':p' )
  local file = vim.secure.read( filepath )
  if not file then
    return nil
  end
  local fn, err = loadstring( file )
  if not fn or err then
    debug.print( 'unable to load ' .. file_name .. '. ' .. err )
    return nil
  end
  local value = fn()
  local validator_type = type( validator )
  if validator_type == 'string' or validator_type == table then
    local expected_types = validator_type == table and validator or { validator, }
    local value_type = type( value )
    local is_valid = vim.iter( expected_types ):any( function ( t ) return t == value_type end )
    return is_valid and value or nil
  end
  return validator( value ) and value or nil
end
