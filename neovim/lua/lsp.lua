-- This function configures all the LSP clients that i might care about.
-- It is expected to be called in the 'config' step of the 'lspconfig' plugin.
return function()
  local integrate_into_neovim = function(client, buffer_number)
    print("LSP started.", vim.inspect(client), buffer_number);
    local chain_complete_list = {
      default = {
        {complete_items = {'lsp', 'snippet'}},
        {complete_items = {'path'}, triggered_only = {'/'}},
        {complete_items = {'buffers'}},
      },
      string = {
        {complete_items = {'path'}, triggered_only = {'/'}},
      },
      comment = {},
    }
    require'completion'.on_attach{
      sorting = 'length',
      enable_auto_popup = false,
      chain_complete_list = chain_complete_list
    }

    local map = function(type, key, value)
      vim.api.nvim_buf_set_keymap(buffer_number,type,key,value,{noremap = true, silent = true});
    end
    map('n','gD','<CMD>lua vim.lsp.buf.declaration()<CR>')
    map('n','gd','<CMD>lua vim.lsp.buf.definition()<CR>')
    map('n','K','<CMD>lua vim.lsp.buf.hover()<CR>')
    map('n','gr','<CMD>lua vim.lsp.buf.references()<CR>')
    map('n','gs','<CMD>lua vim.lsp.buf.signature_help()<CR>')
    map('n','gi','<CMD>lua vim.lsp.buf.implementation()<CR>')
    map('n','gt','<CMD>lua vim.lsp.buf.type_definition()<CR>')
    map('n','<LEADER>gw','<CMD>lua vim.lsp.buf.document_symbol()<CR>')
    map('n','<LEADER>gW','<CMD>lua vim.lsp.buf.workspace_symbol()<CR>')
    map('n','<LEADER>ah','<CMD>lua vim.lsp.buf.hover()<CR>')
    map('n','<LEADER>af','<CMD>lua vim.lsp.buf.code_action()<CR>')
    map('n','<LEADER>ar','<CMD>lua vim.lsp.buf.rename()<CR>')
    map('n','<LEADER>=', '<CMD>lua vim.lsp.buf.formatting()<CR>')
    map('n','<LEADER>ai','<CMD>lua vim.lsp.buf.incoming_calls()<CR>')
    map('n','<LEADER>ao','<CMD>lua vim.lsp.buf.outgoing_calls()<CR>')

    map('n','<LEADER>n','<CMD>lua vim.lsp.diagnostic.goto_next()<CR>')
    map('n','<LEADER>N','<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>')
    map('n','<LEADER><LEADER>','<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  end

  local lsp = require'lspconfig'

  -- Nvim lua configuration LSP
  local neovim_runtime_path = vim.split(package.path, ';')
  table.insert(neovim_runtime_path, 'lua/?.lua')
  table.insert(neovim_runtime_path, 'lua/?/init.lua')
  local sumneko_home = os.getenv'SUMNEKO_HOME'
  local system_name
  if vim.fn.has("mac") == 1 then
    system_name = "macOS"
  elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
  elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
  else
    print("Unsupported system for sumneko")
  end
  --TODO: How to switch this configuration based upon if we are editing neovim configuration or just any Lua file/project?
  lsp.sumneko_lua.setup {
    on_attach = integrate_into_neovim,
    cmd = { sumneko_home .. '/bin/' .. system_name .. '/lua-language-server','-E','-W', sumneko_home .. '/main.lua'},
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = neovim_runtime_path,
        },
        diagnostics = {
          enable = true,
          globals = { 'vim' },
        },
        hint = {
          enable = true,
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = true,
        },
        globals = {
          'cheatsheet',
        }
      }
    }
  }
  -- Markdown Notes (Zettelkasten) LSP
  lsp.zeta_note.setup{
    on_attach = integrate_into_neovim,
    cmd = { 'zeta-note' }
  }

  -- YAML LSP
  lsp.yamlls.setup{
    on_attach = integrate_into_neovim,
    --FIXME: Only works on Windows
    cmd = { 'yaml-language-server.cmd', '--stdio' },
    root_dir = function() return vim.fn.getcwd() end
  }

  -- Zig LSP
  lsp.zls.setup{ on_attach = integrate_into_neovim }

  -- JSON LSP
  lsp.jsonls.setup {
    on_attach = integrate_into_neovim,
    cmd = { 'vscode-json-language-server.cmd', '--stdio' },
    commands = {
      Format = {
        -- Apply the ranged formatting to the whole file
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
  }

  -- GraphViz Dot LSP
  lsp.dotls.setup { on_attach = integrate_into_neovim }
end