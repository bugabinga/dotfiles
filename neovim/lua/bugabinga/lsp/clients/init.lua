local lua = require'bugabinga.lsp.clients.lua'
-- NOTE: The order of clients is implicitly priorization.
-- Put "more specific" clients first
return {
  lua.nvim_lua_ls,
  lua.lua_ls,
}
