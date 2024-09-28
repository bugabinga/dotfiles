-- Options to add `gf` functionality inside `.lua` files.
vim.opt_local.include = [[\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+]]
vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
for _, path in pairs( vim.api.nvim_list_runtime_paths() ) do
  vim.opt_local.path:append( path .. '/lua' )
end
vim.opt_local.suffixesadd:prepend '.lua'

-- i like to mask some lua keywords with cool unicode chars
-- those are defined in 'after/queries/lua/highlights.scm'
vim.opt_local.conceallevel = 1
vim.opt_local.concealcursor = 'n'

vim.snippet.add(
  'fn',
  'function ${1:name}($2)\n\t${3:-- content}\nend',
  { buffer = 0 }
)
vim.snippet.add(
  'lfn',
  'local ${1:name} = function($2)\n\t${3:-- gogogo}\nend',
  { buffer = 0 }
)
