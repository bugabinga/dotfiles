-- TODO setup neodev + jsonls for neovim plugins ans config
-- TODO setup lua_ls for generic lua stuff
-- TODO setup nvimjdtls + lemminx for java/maven
-- TODO setup marksman + ltex for markdown
-- TODO setup mason for "less important" lsps

local map = require'std.keymap'
local auto = require'std.auto'

local _ = {}

local token_update = function(lsp_client)
  local token = lsp_client.data.token
  local buffer = lsp_client.buffer
  local client_id = lsp_client.data.client_id
  local mutable_variable_highlight = 'MutableVariable'
  --TODO(buga): add this highlight to nugu

  if token.type == 'variable' and not token.modifiers.readonly then
    vim.lsp.semantic_tokens.highlight_token(token, buffer, client_id, mutable_variable_highlight)
  end

  --TODO(buga): find more use cases for semantic tokens
end

local lua_config = 
{
  name = 'LuaLS',
  filetypes = 'lua',
  cmd = 'lua-language-server',
  root_dir = project.determine_lua_project_root,
  single_file = true,
  workspaces = true,
}

local lsp_start  = function(...) vim.print("START LSP", ...) end
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


return setmetatable(_ ,{

})
