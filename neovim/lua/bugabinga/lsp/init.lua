-- TODO: setup neodev + jsonls for neovim plugins ans config
-- TODO: setup nvimjdtls + lemminx for java/maven
-- TODO: setup marksman + ltex for markdown
-- TODO: setup mason for "less important" lsps
-- TODO: some snippet plugins seems necessary for some LSPs

local map                = require 'std.keymap'
local auto               = require 'std.auto'
local ui                 = require 'bugabinga.ui'
local table              = require 'std.table'
local ignored            = require 'std.ignored'

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

local expand_path = function(path)
  if vim.fn.executable(path) == 1 then
    return vim.fn.exepath(path)
  else
    return path
  end
end

local expand_command = function(command)
	vim.validate{ command = { command, { 'string', 'table' } }}

	if type(command) == 'table' then 
	  command[1] = expand_path(command[1])
	  return command
  end

  return expand_path(command)
end

local lsp_start          = function ( file_type_event )
  local match = file_type_event.match

  local matches_to_ignore = ignored.filetypes
  if vim.iter( matches_to_ignore ):find( match ) then return end

  -- vim.print("LSP START", file_type_event)

  local bufnr = file_type_event.buf
  local buffer_path = vim.api.nvim_buf_get_name( bufnr )

  -- vim.print( "SEARCHING LSP CLIENT FOR:", match, buffer_path)

  local potential_client_configs = vim.iter( lsp_client_configs )
    :map( function ( config )
      vim.validate {
        config = { config, 'table' },
        ['config.name'] = { config.name, 'string' },
        ['config.filetypes'] = { config.filetypes, { 'string', 'table' } },
        ['config.command'] = { config.command, { 'string', 'table' } },
        ['config.environment'] = { config.environment, 'table', true },
        ['config.root_dir'] = { config.root_dir, 'function', 'string' },
        ['config.single_file_support'] = { config.single_file_support, 'boolean' },
        ['config.settings'] = { config.settings, 'table', true },
        ['config.workspaces'] = { config.workspaces, 'boolean' },
        ['config.before_init'] = { config.before_init, 'function', true },
        ['config.init_options'] = { config.init_options, 'table', true },
        ['config.capabilities'] = { config.capabilities, 'table', true },
      }
      -- normalize scalar values to its vector alternative for easier processing later on
      -- this mutates the lsp client configs! careful!
      config.command = type( config.command ) == 'string' and { expand_command(config.command) } or expand_command(config.command)
      config.filetypes = type( config.filetypes ) == 'string' and { config.filetypes } or config.filetypes
      config.capabilities = config.capabilities or {}
      config.init_options = config.init_options or {}

      return config
    end )
    :filter( function ( config )
      return vim.iter( config.filetypes ):find( match )
    end )
    :totable()

  -- vim.print("POTENTIAL CLIENTS", #potential_client_configs)

  -- find clients, that returns some root_dir for this buffer
  local config = vim.iter( potential_client_configs ):find(
    function ( _ ) return _.root_dir( buffer_path ) ~= nil end
  )

  -- if no client can open this buffer as part of a project (root_dir), then look
  -- for a client with single file support
  -- FIXME: root_dir needs to change if single file mode
  config = config or vim.iter( potential_client_configs ):find(
    function ( _ ) return _.single_file_support end
  )

  if not config then
    vim.print('FOUND NO LSP CLIENT FOR', buffer_path)
    return
  end

  assert( config, 'a matching LSP client config shoud have been found by now!' )

  local root_dir = type(config.root_dir) == "string" and config.root_dir or config.root_dir( buffer_path )
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = table.extend("force", capabilities, config.capabilities)

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
    flags = { allow_incremental_sync = true, debounce_text_changes = 50, exit_timeout = 200 },
    root_dir = root_dir,
  }

  local client_id = vim.lsp.start( start_config, {
    bufnr = bufnr,
    -- TODO: reuse if workspaces
    -- local supported = vim.tbl_get(client, 'server_capabilities', 'workspace', 'workspaceFolders', 'supported')
    -- reuse_client = function(existing_client, config)end,
  } )

  vim.print("ATTACHING LSP CLIENT", client_id)
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

  -- TODO: create register/unregister abstraction for lsp features
  -- TODO: show available code actions as diagnostics (must be filtered)
  -- TODO: use nicer guis for lsp interactive features
  map.normal {
    name = 'Show available code actions on current line.',
    category = 'lsp',
    keys = '<c-1>',
    command = vim.lsp.buf.code_action,
  }

  map.normal {
    name = 'Goto to definition of symbol under cursor.',
    category = 'lsp',
    keys = '<c-2>',
    command = vim.lsp.buf.definition,
  }
  map.normal {
    name = 'Goto to definition of symbol under cursor.',
    category = 'telescope',
    keys = '<c-2><c-2>',
    command = '<cmd>Telescope lsp_definitions<cr>',
  }

  if client.server_capabilities.documentHighlightProvider then
    auto 'document_highlight' {
      {
        description = 'Highlight symbol under cursor on hold',
        events = 'CursorHold',
        pattern = '<buffer>',
        command = vim.lsp.buf.document_highlight,
      },
      --TODO: debounce cursormoved events
      {
        description = 'Remove highlight from symbol under cursor on move',
        events = { 'CursorMoved', 'InsertEnter' },
        pattern = '<buffer>',
        command = vim.lsp.buf.clear_references,
      }
    }
  end

  --TODO: what can we do with those?
  --maybe: LspCommand <command> <args>
  -- map to <c-3>
  if client.server_capabilities.executeCommandProvider then
    -- [1] ≔ 󰝗 lua.removeSpace 󰉾,
    -- [2] ≔ 󰝗 lua.solve 󰉾,
    -- [3] ≔ 󰝗 lua.jsonToLua 󰉾,
    -- [4] ≔ 󰝗 lua.setConfig 󰉾,
    -- [5] ≔ 󰝗 lua.getConfig 󰉾,
    -- [6] ≔ 󰝗 lua.autoRequire 󰉾,
  end

  map.normal {
    name = 'Format current buffer',
    category = 'lsp',
    keys = '<c-F>',
    command = vim.lsp.buf.format,
  }

  map.normal {
    name = 'Show hover documentation above cursor.',
    category = 'lsp',
    keys = '<c-q>',
    command = vim.lsp.buf.hover,
  }

  map.normal {
    name = 'Show implementations of symbol under cursor.',
    category = 'lsp',
    keys = '<c-4>',
    command = vim.lsp.buf.implementation,
  }
  map.normal {
    name = 'Show implementations of symbol under cursor.',
    category = 'telescope',
    keys = '<c-4><c-4>',
    command = '<cmd>Telescope lsp_implementations<cr>',
  }

  map.normal {
    name = 'Show incoming calls of symbol under cursor.',
    category = 'lsp',
    keys = '<c-5>',
    command = vim.lsp.buf.incoming_calls,
  }
  map.normal {
    name = 'Show incoming calls of symbol under cursor.',
    category = 'telescope',
    keys = '<c-5><c-5>',
    command = '<cmd>Telescope lsp_incoming_calls<cr>',
  }
  map.normal {
    name = 'Show outgoing calls of symbol under cursor.',
    category = 'lsp',
    keys = '<c-s-5>',
    command = vim.lsp.buf.outgoing_calls,
  }
  map.normal {
    name = 'Show outgoing calls of symbol under cursor.',
    category = 'telescope',
    keys = '<c-s-5><c-s-5>',
    command = '<cmd>Telescope lsp_outgoing_calls<cr>',
  }

  map.normal {
    name = 'Show references of symbol under cursor.',
    category = 'lsp',
    keys = '<c-6>',
    command = vim.lsp.buf.references,
  }
  map.normal {
    name = 'Show references of symbol under cursor.',
    category = 'telescope',
    keys = '<c-6><c-6>',
    command = vim.lsp.buf.references,
  }

  map.normal {
    name = 'Rename symbol under cursor.',
    category = 'lsp',
    keys = '<c-R>',
    command = vim.lsp.buf.rename,
  }

  map.normal {
    name = 'Show signature help under cursor.',
    category = 'lsp',
    keys = '<c-7>',
    command = vim.lsp.buf.signature_help,
  }

  map.normal {
    name = 'Show signature help under cursor.',
    category = 'telescope',
    keys = '<c-7><c-7>',
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
  local active_clients = vim.lsp.get_clients( all_or_current )

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

vim.api.nvim_create_user_command( 'LspInfo',
  lsp_info,
  {
    nargs = '?',
    complete = function () return { 'all' } end,
    desc = 'Shows basic information about running LSP clients.',
  } )

vim.api.nvim_create_user_command( 'LspInfoExtended',
  lsp_info_extended,
  {
    nargs = '?',
    complete = function () return { 'all' } end,
    desc = 'Shows detailed information about running LSP clients.',
  } )
return setmetatable( _, {} )
