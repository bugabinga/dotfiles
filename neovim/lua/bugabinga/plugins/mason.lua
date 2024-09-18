return {
  "williamboman/mason.nvim",
  lazy = false,
  opts = {
    ui = {
      border = vim.g.border_style,
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      }
    }
  }
}
