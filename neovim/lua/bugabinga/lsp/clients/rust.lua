local project = require 'std.project'

--TODO: can this be used as general template for all kinds of lsp commands?
local function reload_workspace( bufnr )
  local clients = vim.lsp.get_active_clients { name = 'rust_analyzer', bufnr = bufnr, }
  for _, client in ipairs( clients ) do
    vim.notify 'Reloading Cargo Workspace'
    client.request( 'rust-analyzer/reloadWorkspace', nil, function ( err )
                      if err then
                        error( tostring( err ) )
                      end
                      vim.notify 'Cargo workspace reloaded'
                    end, 0 )
  end
end

local is_descendant = function ( root, path )
  if not path then return false end

  for directory in vim.fs.parents( path ) do
    if vim.fs.normalize( root ) == vim.fs.normalize( directory ) then return true end
  end

  return false
end

local function is_library( fname )
  local user_home = vim.fs.normalize( vim.env.HOME )
  local cargo_home = os.getenv 'CARGO_HOME' or vim.fs.joinpath( user_home, '.cargo' )
  local registry = vim.fs.joinpath( cargo_home, 'registry', 'src' )
  local git_registry = vim.fs.joinpath( cargo_home, 'git', 'checkouts' )

  local rustup_home = os.getenv 'RUSTUP_HOME' or vim.fs.joinpath( user_home, '.rustup' )
  local toolchains = vim.fs.joinpath( rustup_home, 'toolchains' )

  for _, item in ipairs { toolchains, registry, git_registry, } do
    if is_descendant( item, fname ) then
      local clients = vim.lsp.get_active_clients { name = 'rust_analyzer', }
      return #clients > 0 and clients[#clients].config.root_dir or nil
    end
  end
end


return {
  name = 'rust-analyzer',
  command = 'rust-analyzer',
  filetypes = 'rust',
  root_dir = function ( path )
    local library_root = is_library( path )
    if library_root then return library_root end
    return project.find_rust_project_root( path )
  end,
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
  commands = {
    CargoReload = {
      function ()
        reload_workspace( 0 )
      end,
      description = 'Reload current cargo workspace',
    },
  },
}
