-- TODO: setup neodev + jsonls for neovim plugins ans config
-- TODO: setup lua_ls for generic lua stuff
-- TODO: setup nvimjdtls + lemminx for java/maven
-- TODO: setup marksman + ltex for markdown
-- TODO: setup mason for "less important" lsps
-- TODO: LspInfo clone

local map = require'std.keymap'
local auto = require'std.auto'
local deep_concat = require'std.table.deep_concat'

local lsp_client_configs = require'bugabinga.lsp.clients'

local _ = {}

local token_update = function(lsp_client)
  local token = lsp_client.data.token
  local buffer = lsp_client.buffer
  local client_id = lsp_client.data.client_id
  local mutable_variable_highlight = 'MutableVariable'

  if token.type == 'variable' and not token.modifiers.readonly then
    vim.lsp.semantic_tokens.highlight_token(token, buffer, client_id, mutable_variable_highlight)
  end

  --TODO: find more use cases for semantic tokens
  --* global variables
  --* functions with side effects
  --* closures that capture something
end


local lsp_start  = function(file_type_event)

  local match = file_type_event.match

  local matches_to_ignore = {'noice', 'notify', 'help', 'TelescopePrompt', 'TelescopeResults', 'toggleterm', 'lazy', 'oil'}
  if vim.iter(matches_to_ignore):find(match) then return end

  -- vim.print("LSP START", file_type_event)

  local bufnr = file_type_event.buf
  local buffer_path = vim.api.nvim_buf_get_name(bufnr)

  -- vim.print( "SEARCHING LSP CLIENT FOR:", match, buffer_path)


  local potential_client_configs = vim.iter(lsp_client_configs)
    :map(function(config)
      vim.validate{
        config = { config, 'table' },
        ['config.name'] = { config.name, 'string'},
        ['config.filetypes']= { config.filetypes, {'string', 'table'}},
        ['config.command'] = { config.command, { 'string', 'table'}},
        ['config.environment'] = { config.environment, 'table', true },
        ['config.root_dir'] = { config.root_dir, 'function', 'string'},
        ['config.single_file_support'] = { config.single_file_support, 'boolean'},
        ['config.settings'] = { config.settings, 'table', true },
        ['config.workspaces'] = { config.workspaces, 'boolean'},
        ['config.before_init'] = { config.before_init, 'function', true},
      }
      -- normalize scalar values to its vector alternative for easier processing later on
      -- NOTE: this mutates the lsp client configs! careful!
      config.command = type(config.command) == 'string' and { config.command } or config.command
      config.filetypes = type(config.filetypes) == 'string' and { config.filetypes } or config.filetypes
      return config
    end)
    :filter(function(config)
      return vim.iter(config.filetypes):find(match)
    end)
  :totable()

  -- vim.print("POTENTIAL CLIENTS", #potential_client_configs)

  -- find clients, that returns some root_dir for this buffer
  local config = vim.iter(potential_client_configs):find(
    function(_) return _.root_dir(buffer_path) ~= nil end
  )

  -- if no client can open this buffer as part of a project (root_dir), then look
  -- for a client with single file support
  -- FIXME: root_dir needs to change if single file mode
  config = config or vim.iter(potential_client_configs):find(
    function(_) return _.single_file_support end
  )

  if not config then
    vim.print('FOUND NO LSP CLIENT FOR', buffer_path)
    return
  end

  assert(config, 'a matching LSP client config shoud have been found by now!')

  local start_config = {
    cmd = config.command,
    cmd_cwd = config.root_dir(buffer_path),
    -- cmd_env = config.environment,
    detached = false, -- do i want this?
    -- workspace_folders = { config.root_dir(buffer_path) }, -- TODO: i think workspaces can only ever be declared per project. i cannot think of a generic way to calculate those, like with root_dir. maybe a toml/ini file in root_dir sets these?
    -- capabilities = vim.lsp.protocol.make_client_capabilities(),
    -- handlers = vim.lsp.handlers,
    settings = config.settings,
    -- commands = nil, -- what is this?
    -- init_options = nil,
    name = config.name,
    -- get_language_id = nil,
    -- offset_encoding = nil,
    on_error = function(code, ...) vim.print('LSP ERROR', code, ...) end,
    before_init = config.before_init,
    -- on_init = nil, -- should i send workspace/didChangeConfiguration here?
    on_exit = function(code, signal, client_id) vim.print("LSP CLIENT EXIT", code, signal, client_id) end,
    on_attach = function(client, bufnr) vim.print("LSP CLIENT ATTACH", client.data.client_id, bufnr) end,
    trace = 'off',
    flags = { allow_incremental_sync = true, debounce_text_changes = 50, exit_timeout = 200},
    root_dir = config.root_dir(buffer_path),
  }

  --TODO: augment other arguments from start_client
  local client_id = vim.lsp.start(start_config, {
    bufnr = bufnr,
    -- TODO: reuse if workspaces
    -- local supported = vim.tbl_get(client, 'server_capabilities', 'workspace', 'workspaceFolders', 'supported')
    -- reuse_client = function(existing_client, config)end,
  })

  vim.print("ATTACHING LSP CLIENT", client_id)
end

local lsp_attach = function(...) vim.print("ATTACH LSP", ...) end
local lsp_detach = function(...) vim.print("DETACH LSP", ...) end

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

local lsp_info = function(command)
  local all_or_current = command.args and command.args == 'all' and {} or { bufnr = 0 }
  local active_clients = vim.lsp.get_active_clients(all_or_current)

  -- basic info is:
  -- * id
  -- * name
  -- * cmd
  --  * pid, cpu, mem
  -- * root_dir/workspaces
  -- * filetypes
  -- * single file support
  -- * workspaces support
  -- * buffers (if 'all')
  --
  -- TODO extended infos (needs GUI)
  -- * client caps
  -- * server caps
  -- * settings
  -- * ...

  local infos = vim.iter(active_clients)
    :map(function(client)
      local name = client.name
      local config = vim.iter(lsp_client_configs):find(function(config) return config.name == name end)
      assert(config, ( 'How did we not find a config for %s ?!?!' ):format(name))
    local basic = {
        id = client.id,
        name = name,
        --TODO: find cmd in (neovim) PATH
        cmd = { client.config.cmd, client.config.cmd_cwd, 'TODO:pid', 'TODO:cpu', 'TODO:mem'},
        workspace_folders = vim.iter(client.workspace_folders):map(function(w) return vim.fs.normalize(w.name) end):totable(),
        filetypes = config.filetypes,
        single_file_support = config.single_file_support,
        workspaces = config.workspaces,
    }
    return basic
  end)
  :totable()

  --TODO replace with GUI
  vim.print(deep_concat(infos))
end

vim.api.nvim_create_user_command ('LspInfo',
  lsp_info,
  {
    nargs = '?',
    complete = function() return {"all"} end,
    desc = 'Shows basic information about running LSP clients.',
  })

return setmetatable(_ ,{ })
