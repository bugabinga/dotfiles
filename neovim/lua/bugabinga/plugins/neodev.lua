return {
  'folke/neodev.nvim',
  opts = {
    -- With lspconfig, Neodev will automatically setup your lua-language-server
    -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
    -- in your lsp start options
    lspconfig = false,
  },
}
