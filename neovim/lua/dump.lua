-- This function prints the contents of any lua value into the vim output command stream.
-- It is meant to aid in debugging and understanding the state of a running Vim instance.
-- As such it should be imported into the global namespace `_G`, if one wishes to use it
-- live.
-- In essence, this is a shorter way to write: `print(vim.inspect(...))`
return function(...)
  -- vim.inspect converts lua values to something human readable
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end
