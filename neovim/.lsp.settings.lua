return {
  LuaLS = {
    Lua = {
      diagnostics = { globals = { 'vim', 'prequire', }, },
      runtime = { version = 'LuaJIT', },
      workspace = {
        library = { prequire 'neodev.config'.types(), },
      },
    },
  },
}
