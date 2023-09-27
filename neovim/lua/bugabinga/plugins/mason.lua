return {
  "williamboman/mason.nvim",
  -- needs to be loaded early, so that LSP can find programs in PATH
  lazy = false,
  cmd = { 'Mason', 'MasonUpdate', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
  opts = {
    ui = {
      border = vim.g.border_style,
      width = 0.69,
      height = 0.69,
    }
  },
}
