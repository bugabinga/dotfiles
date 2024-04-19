return {
  'williamboman/mason.nvim',
  version = '1.*',
  lazy = false,
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
          'typos',
          'gitleaks',
          'mdslw',
        },
      },
    },
  },
}
