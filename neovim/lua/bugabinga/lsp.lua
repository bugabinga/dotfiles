local icon = require 'std.icon'
local map = require 'std.keymap'
local auto = require 'std.auto'
local project = require 'std.project'
local want = require 'std.want'

-- TODO: setup codelens -> use lsp-signature plugin?
-- TODO: setup custom cmp keybinds
want {
  'lsp-zero',
  'null-ls',
  'nvim-lsp-installer',
  'neodev',
  'rust-tools',
  'nvim-navic',
  'lsp-status',
}(function(zero, null_ls, installer, neodev, rust, navic, lsp_status)
  installer.settings {
    ui = {
      --TODO: use some global float window settings
      border = 'rounded',
    },
  }

  zero.preset 'recommended'
  zero.set_preferences {
    configure_diagnostics = false,
    set_lsp_keymaps = false,
    sign_icons = {
      error = icon 'Error',
      warn = icon 'Warning',
      hint = icon 'Hint',
      info = icon 'Information',
    },
  }

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
  neodev.setup {
    lspconfig = zero.defaults.nvim_workspace(),
  }

  -- disable disco mode while typing
  zero.setup_nvim_cmp {
    completion = {
      autocomplete = false,
    },
  }

  local null_opts = zero.build_options 'null-ls'

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
      formatting.stylua,
      formatting.clang_format,
      formatting.jq,
      formatting.protolint,
      formatting.shellharden,
      formatting.shfmt,
      formatting.taplo,

      hover.dictionary,

      diagnostics.actionlint.with(diagnostics_on_save),
      diagnostics.checkmake.with(diagnostics_on_save),
      diagnostics.gitlint.with(diagnostics_on_save),
      diagnostics.protoc_gen_lint.with(diagnostics_on_save),
      diagnostics.protolint.with(diagnostics_on_save),
      diagnostics.selene.with(diagnostics_on_save).with {
        -- null-ls determines the root in a too simplistic manner.
        -- since my neovim configuration live inside my dotfiles, the dotfiles root
        -- was taken. but i want the neovim config folder as root.
        cwd = function(parameters)
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

  local function setup_keybinds_and_actions(client, buffer_number)
  	-- TODO: use buffer number in keymaps
    -- TODO: make format changed lines command
    local capabilities = client.server_capabilities
    if capabilities.document_formatting then
      map.normal {
        name = 'Format buffer using LSP',
        category = "editing",
        keys = '<leader>' .. 'l' .. 'f',
        command = function()
          vim.lsp.buf.format { bufnr = buffer_number }
          vim.notify('Formatted ' .. vim.api.nvim_buf_get_name(buffer_number))
        end,
      }
    end
    if capabilities.document_range_formatting then
      map.visual {
        name = 'Format range using LSP',
        category = 'editing',
        keys = '<leader>' .. 'l' .. 'f',
        command = function()
          vim.lsp.buf.range_formatting { bufnr = buffer_number }
          vim.notify('Formatted range in ' .. vim.api.nvim_buf_get_name(buffer_number))
        end,
      }
    end
    --TODO: change some of these commands to telescoped versions
    if capabilities.hover then
      map.normal {
        name = 'Show Hover',
        category = 'view',
        keys = '<leader>' .. 'l' .. 'k',
        command = vim.lsp.buf.hover,
      }
    end
    if capabilities.goto_definition then
      map.normal {
        name = 'Go to Definition',
        category = 'navigation',
        keys = '<leader>' .. 'l' .. 'd',
        command = vim.lsp.buf.definition,
      }
    end
    if capabilities.declaration then
      map.normal {
        name = 'Go to Declaration',
        category = 'navigation',
        keys = '<leader>' .. 'l' .. 'd' .. 'd',
        command = vim.lsp.buf.declaration,
      }
    end
    if capabilities.implementation then
      map.normal {
        name = 'Go to Implementation',
        category = 'navigation',
        keys = '<leader>' .. 'l' .. 'i',
        command = vim.lsp.buf.implementation,
      }
    end
    if capabilities.type_definition then
      map.normal {
        name = 'Go to Type Definition',
        category = 'navigation',
        keys = '<leader>' .. 'l' .. 't',
        command = vim.lsp.buf.type_definition,
      }
    end
    if capabilities.find_references then
      map.normal {
        name = 'Go to References',
        category = 'navigation',
        keys = '<leader>' .. 'l' .. 'r',
        command = vim.lsp.buf.references
      }
    end
    if capabilities.call_hierarchy then
      map.normal {
        name = 'Go to Incoming Call',
        category = 'navigation',
        keys = '<leader>' .. 'l' .. 'c',
        command = vim.lsp.buf.incoming_calls,
      }
      map.normal {
        name = 'Go to Outgoing Call',
        category = 'navigation',
        keys = '<leader>' .. 'l' .. 'c' .. 'c',
        command = vim.lsp.buf.outgoing_calls,
      }
    end
    if capabilities.rename then
      map.normal {
        name = 'Rename symbol',
        category = 'editing',
        keys = 'f'2,
        command = vim.lsp.buf.rename,
      }
    end
    if capabilities.code_action then
      map.normal {
        name = 'Show code actions',
        category = 'view',
        keys = 'f'4,
        command = vim.lsp.buf.code_action,
      }
      map.visual {
        name = 'Show code actions in range',
        category = 'view',
        keys = 'f'4,
        command = vim.lsp.buf.range_code_action,
      }
    end
    if capabilities.document_highlight then
      -- this variable should technically be scoped to the current buffer.
      -- how to do that?
      local highlight_timer = nil
      auto 'highlight_reference_under_cursor' {
        {
          description = 'Automatically highlight a symbol under cursor',
          events = 'CursorHold',
          pattern = '<buffer>',
          command = function()
            if not highlight_timer then
              highlight_timer = vim.defer_fn(function()
                vim.lsp.buf.document_highlight()
                highlight_timer = nil
              end, 866)
            end
          end,
        },
        {
          description = 'Clear highlighted symbol under cursor',
          events = { 'CursorMoved', 'CursorMovedI', 'InsertEnter' },
          pattern = '<buffer>',
          command = function()
            if highlight_timer then
              highlight_timer:close()
              highlight_timer = nil
            end
            vim.lsp.buf.clear_references()
          end,
        },
      }
    end
  end

  zero.on_attach(function(client, buffer_number)
    if client.name ~= 'null-ls' and not vim.b.lsp_attached then
      navic.attach(client, buffer_number)
      lsp_status.on_attach(client, buffer_number)
      setup_keybinds_and_actions(client, buffer_number)
    end
  end)

  zero.setup()
end)
