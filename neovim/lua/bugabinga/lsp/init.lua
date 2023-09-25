require 'bugabinga.lsp.lightbulb'

local defer              = require 'std.defer'
local map                = require 'std.map'
local auto               = require 'std.auto'
local want               = require 'std.want'
local ui                 = require 'bugabinga.ui'
local table              = require 'std.table'
local ignored            = require 'std.ignored'
local user_command       = vim.api.nvim_create_user_command
local lsp_client_configs = require 'bugabinga.lsp.clients'
local _                  = {}

  local token_update       = function ( lsp_client )
    local token = lsp_client.data.token
    local buffer = lsp_client.buffer
    local client_id = lsp_client.data.client_id
    local mutable_variable_highlight = 'MutableVariable'

    if token.type == 'variable' and not token.modifiers.readonly then
      vim.lsp.semantic_tokens.highlight_token( token, buffer, client_id, mutable_variable_highlight )
    end

    --TODO: find more use cases for semantic tokens
    --* global variables
    --* functions with side effects
    --* closures that capture something
  end

  local expand_path        = function ( path )
    if vim.fn.executable( path ) == 1 then
      return vim.fn.exepath( path )
    else
      return path
    end
  end

  local expand_command     = function ( command )
    vim.validate { command = { command, { 'string', 'table' } } }

    -- vim.print( 'expanding command', command )

    if type( command ) == 'table' then
      command[1] = expand_path( command[1] )
      return command
    end

    return expand_path( command )
  end

  local lsp_start          = function ( file_type_event )
    -- vim.print("LSP START", file_type_event)

    local match = file_type_event.match

    local matches_to_ignore = ignored.filetypes
    -- vim.print('filetypes to ignore', matches_to_ignore)
    if vim.iter( matches_to_ignore ):find( match ) then return end

    local bufnr = file_type_event.buf
    local buffer_path = vim.api.nvim_buf_get_name( bufnr )

    -- vim.print( "SEARCHING LSP CLIENT FOR:", match, buffer_path)

    local potential_client_configs = vim.iter( lsp_client_configs )
      :map( function ( config )
        vim.validate {
          ['config'] = { config, 'table' },
          ['config.name'] = { config.name, 'string' },
          ['config.filetypes'] = { config.filetypes, { 'string', 'table' } },
          ['config.command'] = { config.command, { 'string', 'table' } },
          ['config.environment'] = { config.environment, 'table', true },
          ['config.root_dir'] = { config.root_dir, 'function', 'string' },
          ['config.single_file_support'] = { config.single_file_support, 'boolean', true },
          ['config.settings'] = { config.settings, 'table', true },
          ['config.workspaces'] = { config.workspaces, 'boolean', true },
          ['config.before_init'] = { config.before_init, 'function', true },
          ['config.init_options'] = { config.init_options, 'table', true },
          ['config.capabilities'] = { config.capabilities, 'table', true },
          ['config.custom_start'] = { config.custom_start, 'function', true },
        }
        -- normalize scalar values to its vector alternative for easier processing later on
        -- this mutates the lsp client configs! careful!
        config.command = type( config.command ) == 'string' and { expand_command( config.command ) } or
          expand_command( config.command )
        config.environment = config.environment or {}
        config.filetypes = type( config.filetypes ) == 'string' and { config.filetypes } or config.filetypes
        config.single_file_support = config.single_file_support == nil and false or config.single_file_support
        config.workspaces = config.workspaces == nil and false or config.workspaces
        config.capabilities = config.capabilities or {}
        config.init_options = config.init_options or {}

        return config
      end )
      :filter( function ( config )
        return vim.iter( config.filetypes ):find( match )
      end )
      :totable()

    -- vim.print("POTENTIAL CLIENTS", vim.iter(potential_client_configs):map(function(config) return { name = config.name, command = config.command } end):totable())

    if table.is_empty( potential_client_configs ) then
      -- vim.notify( 'found no lsp client for', buffer_path )
      return
    end

    for _, config in ipairs( potential_client_configs ) do
      local root_dir = type( config.root_dir ) == 'string' and config.root_dir or config.root_dir( buffer_path )
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_capabilities = want 'cmp_nvim_lsp' ( function ( cmp )
                                                      return cmp.default_capabilities()
                                                    end, {} )
      capabilities = table.extend( 'force', capabilities, cmp_capabilities, config.capabilities )
      -- vim.print( 'lsp capabilities', capabilities, config.capabilities, cmp_capabilities )

      local start_config = {
        cmd = config.command,
        cmd_cwd = root_dir,
        -- cmd_env = config.environment,
        detached = false, -- do i want this?
        -- workspace_folders = { config.root_dir(buffer_path) }, -- TODO: i think workspaces can only ever be declared per project. i cannot think of a generic way to calculate those, like with root_dir. maybe a toml/ini file in root_dir sets these?
        capabilities = capabilities,
        -- handlers = vim.lsp.handlers,
        settings = config.settings,
        -- commands = nil, -- what is this?
        init_options = config.init_options,
        name = config.name,
        -- get_language_id = nil,
        -- offset_encoding = nil,
        on_error = function ( code, ... ) vim.print( 'LSP ERROR', code, ... ) end,
        before_init = config.before_init,
        -- on_init = nil, -- should i send workspace/didChangeConfiguration here?
        -- on_exit = function(code, signal, client_id) vim.print("LSP CLIENT EXIT", code, signal, client_id) end,
        -- on_attach = function(client, bufnr) vim.print("LSP CLIENT ATTACH", client.data.client_id, bufnr) end,
        trace = 'off',
        flags = { allow_incremental_sync = true, debounce_text_changes = 250, exit_timeout = 200 },
        root_dir = root_dir,
      }

      local lsp_starter = config.custom_start or vim.lsp.start

      -- vim.print( 'starting lsp', start_config.name, root_dir )

      lsp_starter( start_config, {
        bufnr = bufnr,
        -- TODO: reuse if workspaces
        -- local supported = vim.tbl_get(client, 'server_capabilities', 'workspace', 'workspaceFolders', 'supported')
        reuse_client = function ( existing_client, new_config )
          --TODO lsps with single file or worksopaces support do not need smame root dir. instead add_workspace_folder
          local same_name_and_root = existing_client.name == new_config.name and
            existing_client.workspace_folders[1] == new_config.root_dir;
          -- vim.print( 'resuing lsp client?', same_name_and_root )
          return same_name_and_root;
        end,
      } )

      -- vim.print("ATTACHING LSP CLIENT", client_id)
    end
  end

  local old_formatexpr
  local old_omnifunc
  local old_tagfunc

  local lsp_attach         = function ( args )
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id( args.data.client_id )
    if not client then return end

    -- vim.print(client.server_capabilities)

    if client.server_capabilities.definitionProvider then
      old_tagfunc = vim.bo[bufnr].tagfunc
      vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
    end

    if client.server_capabilities.documentFormattingProvider then
      old_formatexpr = vim.bo[bufnr].formatexpr
      vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr(#{timeout_ms:50})'
    end

    if client.server_capabilities.completionProvider then
      old_omnifunc = vim.bo[bufnr].omnifunc
      vim.bo[bufnr].omnifunc = 'v:vim.lsp.omnifunc'
    end

    -- if client.server_capabilities.inlayHintProvider then
    -- TODO: how to prevent the UI from jittering
    -- vim.lsp.inlay_hint( bufnr, true )
    -- end

    -- TODO: create register/unregister abstraction for lsp features
    -- TODO: show available code actions as diagnostics (must be filtered)
    -- TODO: use nicer guis for lsp interactive features
    map.normal {
      description = 'Show available code actions on current line.',
      category = 'lsp',
    keys = '<c-1>',
    command = vim.lsp.buf.code_action,
  }

  map.normal {
    description = 'Goto to definition of symbol under cursor.',
    category = 'lsp',
    keys = '<c-2>',
    command = vim.lsp.buf.definition,
  }
  map.normal {
    description = 'Goto to definition of symbol under cursor.',
    category = 'telescope',
    keys = '<c-2><c-2>',
    command = '<cmd>Telescope lsp_definitions<cr>',
  }

  if client.server_capabilities.documentHighlightProvider then
    -- the timer has application lifetime. no need to close
    local delay = 300
    local debounced_highlight = defer.debounce_leading( vim.lsp.buf.document_highlight, delay )
    local debounced_clear = defer.debounce_leading( vim.lsp.buf.clear_references, delay )

    auto 'document_highlight' {
      {
        description = 'Highlight symbol under cursor on hold',
        events = 'CursorHold',
        buffer = bufnr,
        command = debounced_highlight,
      },
      {
        description = 'Remove highlight from symbol under cursor on move',
        events = { 'CursorMoved', 'InsertEnter' },
        buffer = bufnr,
        command = debounced_clear,
      }
    }
  end

  map.normal {
    description = 'Format current buffer',
    category = 'lsp',
    keys = '<c-s>',
    command = vim.lsp.buf.format,
  }

  map.normal {
    description = 'Show hover documentation above cursor.',
    category = 'lsp',
    keys = '<c-0>',
    command = vim.lsp.buf.hover,
  }

  map.normal {
    description = 'Show implementations of symbol under cursor.',
    category = 'lsp',
    keys = '<c-4>',
    command = vim.lsp.buf.implementation,
  }
  map.normal {
    description = 'Show implementations of symbol under cursor.',
    category = 'telescope',
    keys = '<c-4><c-4>',
    command = '<cmd>Telescope lsp_implementations<cr>',
  }

  map.normal {
    description = 'Show incoming calls of symbol under cursor.',
    category = 'lsp',
    keys = '<c-5>',
    command = vim.lsp.buf.incoming_calls,
  }
  map.normal {
    description = 'Show incoming calls of symbol under cursor.',
    category = 'telescope',
    keys = '<c-5><c-5>',
    command = '<cmd>Telescope lsp_incoming_calls<cr>',
  }
  map.normal {
    description = 'Show outgoing calls of symbol under cursor.',
    category = 'lsp',
    keys = '<c-s-5>',
    command = vim.lsp.buf.outgoing_calls,
  }
  map.normal {
    description = 'Show outgoing calls of symbol under cursor.',
    category = 'telescope',
    keys = '<c-s-5><c-s-5>',
    command = '<cmd>Telescope lsp_outgoing_calls<cr>',
  }

  map.normal {
    description = 'Show references of symbol under cursor.',
    category = 'lsp',
    keys = '<c-6>',
    command = vim.lsp.buf.references,
  }
  map.normal {
    description = 'Show references of symbol under cursor.',
    category = 'telescope',
    keys = '<c-6><c-6>',
    command = vim.lsp.buf.references,
  }

  map.normal {
    description = 'Rename symbol under cursor.',
    category = 'lsp',
    keys = '<c-9>',
    command = vim.lsp.buf.rename,
  }

  map.normal {
    description = 'Show signature help under cursor.',
    category = 'lsp',
    keys = '<c-s-0>',
    command = vim.lsp.buf.signature_help,
  }

  map.normal {
    description = 'Show signature help under cursor.',
    category = 'telescope',
    keys = '<c-s-0><c-s-0>',
    command = '<cmd>Telescope lsp_signature_help<cr>',
  }
end

local lsp_detach         = function ( args )
  -- vim.print("DETACH LSP", ...)

  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id( args.data.client_id )
  if not client then return end

  if client.server_capabilities.definitionProvider then
    vim.bo[bufnr].tagfunc = old_tagfunc
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = old_formatexpr
  end

  if client.server_capabilities.completionProvider then
    vim.bo[bufnr].omnifunc = old_omnifunc
  end
end

auto 'lsp' {
  {
    description = 'Start or reuse LSP client',
    events = 'FileType',
    command = lsp_start,
  },
  {
    description = 'Hook: LSP client attached to buffer',
    events = 'LspAttach',
    command = lsp_attach,
  },
  {
    description = 'Hook: LSP client detached from buffer',
    events = 'LspDetach',
    command = lsp_detach,
  },
  {
    description = 'Semantic Tokens from the LSP',
    events = 'LspTokenUpdate',
    command = token_update,
  }
}

local lsp_info = function ( command )
  local all_or_current = command.args and command.args == 'all' and {} or { bufnr = 0 }
  local active_clients = vim.lsp.get_active_clients( all_or_current )

  local infos = vim.iter( active_clients )
    :map( function ( client )
      local name = client.name
      local config = vim.iter( lsp_client_configs ):find( function ( config ) return config.name == name end )
      assert( config, ('How did we not find a config for %s ?!?!'):format( name ) )

      local full_cmd = table.deep_copy( client.config.cmd )
      full_cmd[1] = vim.fn.exepath( full_cmd[1] )
      local basic = {
        id = client.id,
        name = name,
        cmd = table.concat( full_cmd, ' ' ),
        workspace_folders = vim.iter( client.workspace_folders ):map( function ( w ) return vim.fs.normalize( w.name ) end )
          :totable(),
        filetypes = table.concat( config.filetypes, ', ' ),
        single_file_support = config.single_file_support,
        workspaces = config.workspaces,
      }
      return basic
    end )
    :totable()

  ui.show_tree( infos )
end

local lsp_info_extended = function ( command )
  local all_or_current = command.args and command.args == 'all' and {} or { bufnr = 0 }
  local active_clients = vim.lsp.get_clients( all_or_current )
  ui.show_tree( active_clients )
end

user_command( 'LspInfo', lsp_info, {
  nargs = '?',
  complete = function () return { 'all' } end,
  desc = 'Shows basic information about running LSP clients.',
} )

user_command( 'LspInfoExtended', lsp_info_extended, {
  nargs = '?',
  complete = function () return { 'all' } end,
  desc = 'Shows detailed information about running LSP clients.',
} )

return setmetatable( _, {} )