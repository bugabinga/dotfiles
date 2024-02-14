return {
  "williamboman/mason.nvim",
  cmd = { 'Mason', 'MasonUpdate', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
  opts = {
    ui = {
      border = vim.g.border_style,
      width = 0.69,
      height = 0.69,
    }
  },
}
