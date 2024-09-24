local dbg                = require 'std.dbg'
local icon               = require 'std.icon'
local defer              = require 'std.defer'
local map                = require 'std.map'
local auto               = require 'std.auto'
local ui                 = require 'bugabinga.ui'
local table              = require 'std.table'
local ignored            = require 'std.ignored'
local user_command       = require 'std.user_command'
local lsp_client_configs = require 'bugabinga.lsp.clients'
local localrc            = require 'std.localrc'

local _                  = {}

require 'bugabinga.lsp.lightbulb'

local token_update   = function ( lsp_client )
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

local expand_path    = function ( path )
  if vim.fn.executable( path ) == 1 then
    return vim.fn.exepath( path )
  else
    return path
  end
end

local expand_command = function ( command )
  vim.validate { command = { command, { 'string', 'table' } } }

  if type( command ) == 'table' then
    command[1] = expand_path( command[1] )
    return command
  end

  return expand_path( command )
end

local lsp_start      = function ( file_type_event )
  dbg.print 'trying to start lsp'
  local match = file_type_event.match

  dbg.print( 'filetypes to ignore', ignored.filetypes, 'current filetype', match )
  if vim.iter( ignored.filetypes ):find( match ) then return end

  local bufnr = file_type_event.buf
  local buftype = vim.api.nvim_get_option_value( 'buftype', { buf = bufnr } )
  dbg.print( 'buftypes to ignore', ignored.buftypes, 'current buftype', buftype )
  if vim.iter( ignored.buftypes ):find( buftype ) then return end

  local buffer_path = vim.api.nvim_buf_get_name( bufnr )

  dbg.print( string.format( 'searching lsp client for: match: %s, buffer: %s, path: %s', match, bufnr, buffer_path ) )

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
        ['config.before_init'] = { config.before_init, { 'function', 'table' }, true },
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

  dbg.print( 'POTENTIAL CLIENTS',
             vim.iter( potential_client_configs ):map( function ( config )
               return {
                 name = config.name,
                 command =
                   config.command,
               }
             end )
             :totable() )

  if table.is_empty( potential_client_configs ) then
    dbg.print( 'found no lsp client for', buffer_path )
    return
  end

  --NOTE: this is super kool but has the limitation, that only lsp clients
  -- configured via my special lsp module are affected.
  local project_local_lsp_settings = localrc( '.lsp.settings.lua', 'table' ) or {}
  local project_local_workspace_folders = localrc( '.lsp.workspace_folders.lua', 'table' ) or {}

  -- expand relative workspace paths into lsp.workspaceFolders (name + uri)
  for lsp, folders in pairs( project_local_workspace_folders ) do
    for idx, path in ipairs( folders ) do
      local cwd = vim.uv.cwd()
      local abs_path = vim.fs.normalize( vim.fs.joinpath( cwd, path ) )

      local exists = vim.uv.fs_stat( abs_path )
      if not exists or exists.type ~= 'directory' then
        vim.error( 'the project local workspace folder ' ..
          abs_path .. ' does not exist or is not a directory.' )
      end

      project_local_workspace_folders[lsp][idx] = { uri = 'file://' .. abs_path, name = path }
    end
  end

  dbg.print( 'patched project local workspace folders', project_local_workspace_folders )

  for _, config in ipairs( potential_client_configs ) do
    local path = type( config.command ) == 'table' and config.command[1] or config.command
    if vim.fn.executable( path ) ~= 1 then
      vim.notify( 'The LSP ' .. config.name .. ' does not seem to be installed!' )
      break
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = table.extend( 'force', capabilities, config.capabilities )

    local settings = config.settings
    local settings_override = project_local_lsp_settings[config.name]
    if settings_override then
      dbg.print( 'overriding settings with project local settings', settings, settings_override )
      settings = vim.tbl_deep_extend( 'force', settings, settings_override )
    end

    local root_dir = type( config.root_dir ) == 'string' and config.root_dir or config.root_dir( buffer_path )
    local root_workspace = root_dir and { uri = 'file://' .. root_dir, name = root_dir } or nil
    local workspace_folders = root_workspace and { root_workspace } or nil
    local workspace_folders_local = project_local_workspace_folders[config.name]
    if not workspace_folders_local then dbg.print( 'no local workspace folders found for ' .. config.name ) end
    if workspace_folders_local and config.workspaces then
      dbg.print( 'setting workspace folders to project local workspace folders', workspace_folders_local )
      workspace_folders = workspace_folders and
        vim.tbl_deep_extend( 'force', workspace_folders, workspace_folders_local ) or workspace_folders_local
    end

    dbg.print( 'starting command:', config.command )

    local start_config = {
      cmd = config.command,
      cmd_cwd = root_dir,
      -- cmd_env = config.environment,
      detached = false, -- do i want this?
      root_dir = root_dir,
      workspace_folders = workspace_folders,
      capabilities = capabilities,
      -- handlers = vim.lsp.handlers,
      settings = settings,
      -- commands = nil, -- what is this?
      init_options = config.init_options,
      name = config.name,
      -- get_language_id = nil,
      -- offset_encoding = nil,
      on_error = function ( code, ... ) vim.print( 'LSP ERROR', code, ... ) end,
      before_init = config.before_init,
      -- on_init = nil, -- should i send workspace/didChangeConfiguration here?
      on_exit = function ( code, signal, client_id ) dbg.print( 'LSP CLIENT EXIT', code, signal, client_id ) end,
      on_attach = function ( client, attach_bufnr ) dbg.print( 'LSP CLIENT ATTACH', client, attach_bufnr ) end,
      trace = dbg.get() and 'on' or 'off',
      flags = { allow_incremental_sync = true, debounce_text_changes = 250, exit_timeout = 200 },
    }

    local lsp_starter = config.custom_start or vim.lsp.start

    dbg.print( 'starting lsp', start_config.name, root_dir )

    lsp_starter( start_config, {
      bufnr = bufnr,
      -- TODO: reuse if workspaces
      -- local supported = vim.tbl_get(client, 'server_capabilities', 'workspace', 'workspaceFolders', 'supported')
      reuse_client = function ( existing_client, new_config )
        dbg.print(
          'lsp reuse client',
          existing_client.name,
          existing_client.workspace_folders,
          new_config.name,
          new_config.root_dir
        )

        --TODO lsps with single file or worksopaces support do not need smame root dir. instead add_workspace_folder
        local same_name = existing_client.name == new_config.name

        local new_root_raw = new_config.root_dir or nil
        local existing_root_raw = existing_client.workspace_folders and #existing_client.workspace_folders >= 1 and
          existing_client.workspace_folders[1].name or nil

        if not (new_root_raw and existing_root_raw) then return false end

        local new_root = vim.fs.normalize( new_root_raw )
        local existing_root = vim.fs.normalize( existing_root_raw )
        local same_root = new_root == existing_root

        local reuse = same_name and same_root
        dbg.print( 'reusing lsp client?', reuse )
        return reuse
      end,
    } )

    dbg.print( 'STARTING LSP CLIENT', config.name )
  end
end

local old_formatexpr
local old_omnifunc
local old_tagfunc

local keybinds       = {}
local add            = function ( client_id, keybind_remover )
  vim.validate {
    client_id = { client_id, 'number' },
    keybind_remover = { keybind_remover, 'function' },
  }
  if not table.contains( keybinds, client_id ) then
    keybinds[client_id] = {}
  end
  table.insert( keybinds[client_id], keybind_remover )
end

local lsp_attach     = function ( args )
  local bufnr = args.buf
  local client_id = args.data.client_id
  local client = vim.lsp.get_client_by_id( client_id )
  if not client then return end

  dbg.print( client.server_capabilities )

  if client.server_capabilities.definitionProvider then
    old_tagfunc = vim.bo[bufnr].tagfunc
    vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
  end

  if client.server_capabilities.documentFormattingProvider then
    old_formatexpr = vim.bo[bufnr].formatexpr
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr'
  end

  if client.server_capabilities.completionProvider then
    old_omnifunc = vim.bo[bufnr].omnifunc
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end

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
      },
    }
  end

  if client.server_capabilities.inlayHintProvider then
    add( client_id, map.normal {
      description = 'Toggle inlay hints',
      category = 'lsp',
      buffer = bufnr,
      keys = '<leader>ti',
      command = function ()
        vim.lsp.inlay_hint.enable( bufnr, nil )
      end,
    } )
  end

  add( client_id, map.normal {
    description = 'Show hover documentation above cursor.',
    category = 'lsp',
    buffer = bufnr,
    keys = { 'K', '<leader>lk' },
    command = vim.lsp.buf.hover,
  } )

  add( client_id, map.insert {
    description = 'Show signature help under cursor.',
    category = 'lsp',
    buffer = bufnr,
    keys = { '<C-h>' },
    command = vim.lsp.buf.signature_help,
  } )

  add( client_id, map.normal {
    description = 'Show available code actions on current line.',
    category = 'lsp',
    buffer = bufnr,
    keys = '<leader>la',
    command = vim.lsp.buf.code_action,
  } )

  add( client_id, map.normal {
    description = 'Goto to definition of symbol under cursor.',
    category = 'lsp',
    buffer = bufnr,
    keys = '<leader>ld',
    command = vim.lsp.buf.definition,
  } )

  add( client_id, map.normal {
    description = 'Show implementations of symbol under cursor.',
    category = 'lsp',
    buffer = bufnr,
    keys = '<leader>li',
    command = vim.lsp.buf.implementation,
  } )

  add( client_id, map.normal {
    description = 'Show incoming calls of symbol under cursor.',
    category = 'lsp',
    buffer = bufnr,
    keys = '<leader>lc',
    command = vim.lsp.buf.incoming_calls,
  } )

  add( client_id, map.normal {
    description = 'Show outgoing calls of symbol under cursor.',
    category = 'lsp',
    buffer = bufnr,
    keys = '<leader>lC',
    command = vim.lsp.buf.outgoing_calls,
  } )

  add( client_id, map.normal {
    description = 'Show references of symbol under cursor.',
    category = 'lsp',
    buffer = bufnr,
    keys = '<leader>ln',
    command = vim.lsp.buf.references,
  } )

  add( client_id, map.normal {
    description = 'Rename symbol under cursor.',
    category = 'lsp',
    buffer = bufnr,
    keys = { '<f2>', '<leader>lr' },
    command = vim.lsp.buf.rename,
  } )
end

local lsp_detach     = function ( args )
  dbg.print( 'DETACH LSP', args )

  local bufnr = args.buf
  local client_id = args.data.client_id
  local client = vim.lsp.get_client_by_id( client_id )
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

  if table.contains( keybinds, client_id ) then
    for _, keybind_delete in ipairs( keybinds[client_id] ) do
      keybind_delete()
    end
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
  },
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

user_command.LspInfo
'Shows basic information about running LSP clients.'
  { nargs = '?', complete = function () return { 'all' } end } (
    lsp_info
  )

user_command.LspInfoExtended
'Shows detailed information about running LSP clients.'
  { nargs = '?', complete = function () return { 'all' } end } (
    lsp_info_extended
  )

-- TODO: LspStart
-- TODO: LspStop
-- TODO: LspRestart ? Maybe good after changing project local settings?

local completion_icons = {
  Class = icon.class,
  Color = icon.color,
  Constant = icon.constant,
  Constructor = icon.constructor,
  Enum = icon.enum,
  EnumMember = icon.enum_member,
  Field = icon.field,
  File = icon.file,
  Folder = icon.folder,
  Function = icon['function'],
  Interface = icon.interface,
  Keyword = icon.keyword,
  Method = icon.method,
  Module = icon.module,
  Property = icon.property,
  Snippet = icon.snippet,
  Struct = icon.struct,
  Text = icon.text,
  Unit = icon.unit,
  Value = icon.value,
  Variable = icon.variable,
}

local completion_kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs( completion_kinds ) do
  completion_kinds[i] = completion_icons[kind] or kind
end

return setmetatable( _, {} )
