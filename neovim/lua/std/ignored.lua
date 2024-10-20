-- TODO: add functions to add stuff to lists so that plugins can register these
-- and they get cleaned up when plugins get removed
local filetypes = {
  'NvimTree',
  'Outline',
  'TelescopePrompt',
  'TelescopeResults',
  'Trouble',
  'WhichKey',
  '^git.*',
  'copilot-chat',
  'flash_prompt',
  'help',
  'ivy',
  'lazy',
  'noice',
  'notify',
  'nvim-docs-view',
  'oil',
  'qf',
  'spectre_panel',
  'starter',
  'svn',
  'toggleterm',
  'copilot-chat',
}

local buftypes = {
  'acwrite',
  'help',
  'prompt',
  'nofile',
}

local as_kv = function ( list )
  local tbl = {}
  for _, value in ipairs( list ) do
    vim.validate { value = { value, 'string' } }
    tbl[value] = true
  end
  return tbl
end

local filetypes_kv = as_kv( filetypes )
local buftypes_kv = as_kv( buftypes )

return {
  filetypes = filetypes,
  filetypes_kv = filetypes_kv,
  buftypes = buftypes,
  buftypes_kv = buftypes_kv,
}
