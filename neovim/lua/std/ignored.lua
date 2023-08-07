local filetypes = {
  'gitcommit',
  'gitrebase',
  'svn',
  'hgcommit',
  'help',
  'noice',
  'notify',
  'TelescopePrompt',
  'TelescopeResults',
  'toggleterm',
  'lazy',
  'oil',
}

local buftypes = {
  'noice',
  'neotree',
  'quickfix',
  'help',
  'nofile',
  'acwrite',
}

local as_kv = function(list)
  local tbl = {}
  for _, value in ipairs(list) do
      vim.validate { value = { value, 'string'} }
    tbl[value] = true
  end
  return tbl
end

local filetypes_kv = as_kv(filetypes)
local buftypes_kv = as_kv(buftypes)

return {
  filetypes = filetypes,
  filetypes_kv = filetypes_kv,
  buftypes = buftypes,
  buftypes_kv = buftypes_kv,
}
