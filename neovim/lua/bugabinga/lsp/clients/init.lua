local lua = require'bugabinga.lsp.clients.lua'
local java = require'bugabinga.lsp.clients.java'

-- FIXME: it is not possible right now to start multiple LSPs perf buffer
-- NOTE: The order of clients is implicitly priorization.
-- Put "more specific" clients first
return {
  lua.nvim_lua_ls,
  lua.lua_ls,
  java.jdtls,
  java.jdtls_ss,
  require'bugabinga.lsp.clients.json',
  require'bugabinga.lsp.clients.archlinux',
  require'bugabinga.lsp.clients.asm',
  require'bugabinga.lsp.clients.bash',
  require'bugabinga.lsp.clients.c',
  require'bugabinga.lsp.clients.graphviz',
  require'bugabinga.lsp.clients.markdown',
  require'bugabinga.lsp.clients.rust',
  require'bugabinga.lsp.clients.toml',
  require'bugabinga.lsp.clients.vim',
  require'bugabinga.lsp.clients.xml',
  require'bugabinga.lsp.clients.zig',
}
