return {
  'folke/neodev.nvim',
  opts = {
    -- With lspconfig, Neodev will automatically setup your lua-language-server
    -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
    -- in your lsp start options
    lspconfig = false,
    setup_jsonls = false,
    -- override = function ( root_dir, library )
    --   vim.print( root_dir, library )
    -- end,
  },
}
