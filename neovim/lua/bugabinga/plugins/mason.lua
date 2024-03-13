return {
  'williamboman/mason.nvim',
  tag = 'v1.10.0',
  cmd = { 'Mason', 'MasonUpdate', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog', },
  opts = {
    ui = {
      border = vim.g.border_style,
      width = 0.69,
      height = 0.69,
    },
  },
  dependencies = {
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      lazy = false,
      cmd = { 'MasonToolsInstall', 'MasonToolsInstallSync', 'MasonToolsUpdate', 'MasonToolsUpdateSync', 'MasonToolsClean', },
      opts = {
        ensure_installed = {
          'lua-language-server',
          'shellcheck',
          'editorconfig-checker',
          'shfmt',
          'jdtls',
          'java-test',
          'java-debug-adapter',
          'lemminx',
          'marksman',
        },
      },
    },
  },
}
