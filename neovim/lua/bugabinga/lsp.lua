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

  -- Format on Save when any LSP supports it.
  local auto = require 'bugabinga.std.auto'
  local null_opts = zero.build_options('null-ls', {
    on_attach = function(client)
      if client.server_capabilities.documentFormattingProvider then
        auto 'format_buffer_on_write' {
          description = 'Format the current buffer before writing.',
          events = 'BufWritePre',
          pattern = '<buffer>',
          callback = function(context)
            vim.lsp.buf.format()
            vim.notify('Formatted ' .. context.file)
          end,
        }
      end
    end,
  })

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  local hover = null_ls.builtins.hover
  local completion = null_ls.builtins.completion

  -- run diagnostics on save
  local diagnostics_on_save = { method = null_ls.methods.DIAGNOSTICS_ON_SAVE }
  null_ls.setup {
    on_attach = null_opts.on_attach,
    sources = {
      formatting.black.with { extra_args = { '--fast' } },
      formatting.stylua,
      formatting.clang_format,
      formatting.codespell,
      formatting.jq,
      formatting.protolint,
      formatting.shellharden,
      formatting.shfmt,
      formatting.taplo,

      hover.dictionary,

      diagnostics.actionlint.with(diagnostics_on_save),
      diagnostics.checkmake.with(diagnostics_on_save),
      diagnostics.codespell.with(diagnostics_on_save),
      diagnostics.editorconfig_checker.with(diagnostics_on_save).with { command = 'editorconfig-checker' },
      diagnostics.gitlint.with(diagnostics_on_save),
      diagnostics.protoc_gen_lint.with(diagnostics_on_save),
      diagnostics.protolint.with(diagnostics_on_save),
      diagnostics.selene.with(diagnostics_on_save).with {
        -- null-ls determines the root in a too simplistic manner.
        -- since my neovim configuration live inside my dotfiles, the dotfiles root
        -- was taken. but i want the neovim config folder as root.
        cwd = function(parameters)
          local project = require 'bugabinga.std.project'
          local root = project.determine_project_root({ name = 'selene.toml', weight = 10 }, parameters.root)
          return root or parameters.root
        end,
      },
      diagnostics.shellcheck.with(diagnostics_on_save),
      diagnostics.tidy.with(diagnostics_on_save),

      code_actions.refactoring,
      code_actions.shellcheck,

      completion.luasnip,
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
