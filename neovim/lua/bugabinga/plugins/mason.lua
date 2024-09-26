return {
  'williamboman/mason.nvim',
  version = '1.*',
  lazy = false,
  opts = {
    ui = {
      border = vim.g.border_style,
      icons = {
        -- TODO: use my icons
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  },
}
