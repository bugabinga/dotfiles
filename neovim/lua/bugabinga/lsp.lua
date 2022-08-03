local want = require 'bugabinga.std.want'
want {
  'lsp-zero',
  'null-ls',
  'nvim-lsp-installer',
  'lua-dev',
  'rust-tools',
  'nvim-navic',
  'lsp-status',
}(function(zero, null_ls, installer, luadev, rust, navic, lsp_status)
  installer.settings {
    ui = {
      border = 'rounded',
    },
  }

  zero.preset 'recommended'

  -- setup lsp for my neovim config
  zero.nvim_workspace {
    -- add paths of all plugins and neovim
    library = vim.api.nvim_get_runtime_file('', true),
  }
  -- Initialize rust_analyzer with rust-tools
  rust.setup {
    server = zero.build_options('rust_analyzer', {}),
  }

  -- this will prevent zero from loading this server.
  -- Java will be managed by nvim-jdtls, which wants to do things differently.
  -- see ftplugin/java.lua
  zero.build_options('jdtls', {})

  -- lua neovim lsp
  luadev.setup {
    lspconfig = zero.defaults.nvim_workspace(),
  }

  -- disable disco mode while typing
  zero.setup_nvim_cmp {
    completion = {
      autocomplete = false,
    },
  }

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  -- local hover = null_ls.builtins.hover
  local completion = null_ls.builtins.completion

  -- run diagnostics on save
  local diagnostics_on_save = { method = null_ls.methods.DIAGNOSTICS_ON_SAVE }

  local null_opts = zero.build_options 'null-ls'
  null_ls.setup {
    on_attach = null_opts.on_attach,
    sources = {
      formatting.stylua,
      formatting.clang_format,
      formatting.jq,
      formatting.protolint,
      formatting.shellharden,
      formatting.shfmt,
      formatting.taplo,
      formatting.google_java_format,
      formatting.tidy,

      diagnostics.actionlint.with(diagnostics_on_save),
      diagnostics.checkmake.with(diagnostics_on_save),
      diagnostics.editorconfig_checker.with(diagnostics_on_save).with { command = 'editorconfig-checker' },
      diagnostics.protoc_gen_lint.with(diagnostics_on_save),
      diagnostics.protolint.with(diagnostics_on_save),
      diagnostics.selene.with(diagnostics_on_save),
      diagnostics.shellcheck.with(diagnostics_on_save),
      diagnostics.tidy.with(diagnostics_on_save),
      diagnostics.trail_space.with(diagnostics_on_save),

      code_actions.refactoring,
      code_actions.shellcheck,
      code_actions.gitsigns,

      completion.spell,
      completion.tags,
    },
  }

  zero.on_attach(function(client, buffer_number)
    if client.name ~= 'null-ls' and not vim.b.lsp_attached then
      navic.attach(client, buffer_number)
      lsp_status.on_attach(client, buffer_number)
    end
  end)

  zero.setup()
end)
