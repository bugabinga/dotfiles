-- TODO: setup neodev + jsonls for neovim plugins ans config
-- TODO: setup lua_ls for generic lua stuff
-- TODO: setup nvimjdtls + lemminx for java/maven
-- TODO: setup marksman + ltex for markdown
-- TODO: setup mason for "less important" lsps
-- TODO: LspInfo clone

local map = require'std.keymap'
local auto = require'std.auto'

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
  --TODO: global variables
end


local lsp_start  = function(file_type_event)

  local match = file_type_event.match

  local matches_to_ignore = {'noice', 'notify', 'help', 'TelescopePrompt', 'TelescopeResults', 'toggleterm', 'lazy', 'oil'}
  if vim.iter(matches_to_ignore):find(match) then return end

  -- vim.print("LSP START", file_type_event)

  local buffer_path = vim.api.nvim_buf_get_name(file_type_event.buf)

  vim.print( "SEARCHING LSP CLIENT FOR:", match, buffer_path)

  local lsp_client_configs = require'bugabinga.lsp.clients'

  local potential_client_configs = vim.iter(vim.deepcopy(lsp_client_configs))
    :map(function(config)
      vim.validate{
        config = { config, 'table' },
        ['config.name'] = { config.name, 'string'},
        ['config.filetypes']= { config.filetypes, {'string', 'table'}},
        ['config.cmd'] = { config.cmd, { 'string', 'table'}},
        ['config.root_dir'] = { config.root_dir, 'function'},
        ['config.single_file_support'] = { config.single_file_support, 'boolean'},
        ['config.workspaces'] = { config.workspaces, 'boolean'},
      }
      config.cmd = type(config.cmd) == 'string' and { config.cmd } or config.cmd
      config.filetypes = type(config.filetypes) == 'string' and { config.filetypes } or config.filetypes
      config.root_dir = config.root_dir(buffer_path)
      return config
    end)
    :filter(function(config)
      return vim.iter(config.filetypes):find(match)
    end)
  :totable()

  vim.print("POTENTIAL CLIENTS", #potential_client_configs)

  -- find clients, that returns some root_dir for this buffer
  local config = vim.iter(potential_client_configs):find(
    function(_) return _.root_dir ~= nil end
  )

  -- if no client can open this buffer as part of a project (root_dir), then look
  -- for a client with single file support
  -- FIXME: root_dir needs to change if single file mode
  config = config or vim.iter(potential_client_configs):find(
    function(_) return _.single_file_support end
  )

  if config then vim.print('FOUND LSP CLIENT', config.name) end

  --TODO: augment other arguments from start_client
  local client_id = vim.lsp.start(config)
  vim.print("ATTACHING LSP CLIENT", client_id)
  

  --TODO: workspaces
  -- local supported = vim.tbl_get(client, 'server_capabilities', 'workspace', 'workspaceFolders', 'supported')

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


return setmetatable(_ ,{ })
