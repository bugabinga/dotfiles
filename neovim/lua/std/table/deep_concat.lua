return function( some_table, options)
  options = options or {}

  vim.validate{
    some_table = { some_table, 'table'},
    [ 'options.prefix' ] = {options.prefix, 'string', true},
    [ 'options.suffix' ] = {options.suffix, 'string', true},
    [ 'options.fill' ] = {options.fill, 'string', true},
    [ 'options.key_value_delimiter' ] = {options.key_value_delimiter, 'string', true},
    [ 'options.row_delimiter' ] = {options.row_delimiter, 'string', true},
    [ 'options.newline' ] = {options.newline, 'string', true},
    [ 'options.render_key' ] = {options.render_key, 'function', true},
    [ 'options.render_value' ] = {options.render_value, 'function', true},
  }

  local prefix = options.prefix or '⦃'
  local suffix = options.suffix or '⦄'
  local key_value_delimiter = options.key_value_delimiter or ' ≔ '
  local row_delimiter = options.row_delimiter or ','
  local fill = options.fill or '  '
  local newline = options.newline or '\n'
  local render_key = options.render_key or function(key) return type(key) == 'number' and ('['..key..']') or key end
  local render_value = options.render_value or function(value) return tostring(value):gsub('\n','') end
  local string_builder = {}
  local append = function(thing) table.insert(string_builder, thing) end

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
