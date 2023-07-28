--- Facade over various table functions in lua, neovim and some of my own.
--- @see #_G.table
--- @see #vim.tbl_*
return {
  human_readable = require'std.table.human_readable',
  deep_concat = require'std.table.deep_concat',
  join = require'std.table.join',

	add_reverse_lookup = vim.tbl_add_reverse_lookup,
	contains = vim.tbl_contains,
  count = vim.tbl_count,
  deep_extend = vim.tbl_deep_extend,
  extend = vim.tbl_extend,
  filter = vim.tbl_filter,
  flatten = vim.tbl_flatten,
  get = vim.tbl_get,
  is_array = vim.tbl_isarray,
  is_empty = vim.tbl_isempty,
  is_list = vim.tbl_islist,
  keys = vim.tbl_keys,
  map = vim.tbl_map,
  values = vim.tbl_values,

  concat = table.concat,
  foreach = table.foreach,
  foreachi = table.foreachi,
  insert = table.insert,
  maxn = table.maxn,
  remove = table.remove,
  sort = table.sort,
}
