return function(some_table, prefix, suffix, key_value_delimiter, row_delimiter, fill, newline)
  vim.validate{
    some_table = { some_table, 'table'},
    prefix = {prefix, 'string', true},
    suffix = {suffix, 'string', true},
    fill = {fill, 'string', true},
    key_value_delimiter = {key_value_delimiter, 'string', true},
    row_delimiter = {row_delimiter, 'string', true},
    newline = {newline, 'string', true},
  }
  prefix = prefix or '⦃'
  suffix = suffix or '⦄'
  key_value_delimiter = key_value_delimiter or ' ≔ '
  row_delimiter = row_delimiter or ','
  fill = fill or '  '
  newline = newline or '\n'
  local string_builder = {}
  local append = function(thing) table.insert(string_builder, thing) end
  local render_key = function(key) return type(key) == 'number' and ('['..key..']') or key end
  local render_value = function(value) return tostring(value):gsub('\n','') end
  local function deep_concat_table (tbl, level)
    level = level or 0
    if newline then append(fill:rep(level)) end
    append(prefix)
    append(newline)
    for key, value in pairs(tbl) do
      local next_level = level + 1
      if newline then append(fill:rep(next_level)) end
      append(render_key(key))
      append(key_value_delimiter)
      if type(value) == 'table' then
        if vim.tbl_isempty(value) then
          append(prefix)
          append(suffix)
        elseif vim.tbl_count(value) == 1 then
          append(prefix)
          append(fill)
          -- single iteration for loop to get key name
          for k,v in pairs(value) do
            append(render_key(k))
            append(key_value_delimiter)
            append(render_value(v))
          end 
          append(fill)
          append(suffix)
        else
          append(newline)
          deep_concat_table(value, next_level)
        end
      else
        append(render_value(value))
      end
      append(row_delimiter)
      append(newline)
    end
    append(newline)
    if newline then append(fill:rep(level)) end
    append (suffix)
  end
  deep_concat_table(some_table)
  return table.concat(string_builder)
end
