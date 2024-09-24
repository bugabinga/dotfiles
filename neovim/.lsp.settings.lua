return {
  LuaLS = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'prequire' } },
      workspace = {
        checkThridParties = false,
        library = {
          '${3rd}/luv/library',
          unpack( vim.api.nvim_get_runtime_file( '', true ) ),
        },
      },
    },
  },
}
