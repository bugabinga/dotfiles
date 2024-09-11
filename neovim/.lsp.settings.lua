return {
  LuaLS = {
    Lua = {
      diagnostics = { globals = { 'vim', 'prequire', }, },
      runtime = { version = 'LuaJIT', },
      workspace = {
        library = vim.api.nvim_get_runtime_file("",true),
      },
    },
  },
}
