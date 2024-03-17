return {
  {
    'rktjmp/lush.nvim',
    -- tag = 'v2.0.1',
    -- we rely on injects.sym for better treesitter support
    branch = 'main',
    -- lazy = false,
    -- priority = 1000,
    config = function ()
      -- disabled to find theming issues with heirline
      -- vim.cmd.colorscheme 'nugu'
    end,
  },
}
