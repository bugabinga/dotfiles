local project = require'std.project'

local function is_library(path)
  local cargo_home = os.getenv 'CARGO_HOME' or vim.fs.joinpath(vim.env.HOME, '.cargo')
  local registry = vim.fs.joinpath(cargo_home, 'registry', 'src')

  local rustup_home = os.getenv 'RUSTUP_HOME' or vim.fs.joinpath(vim.env.HOME, '.rustup')
  for _, item in ipairs { toolchains, registry } do
    if path:sub(1, #item) == item then
      local clients = vim.lsp.get_active_clients { name = 'rust_analyzer' }
      return #clients > 0 and clients[#clients].config.root_dir or nil
    end
  end
end


return {
  name = 'rust-analyzer', 
  command = 'rust-analyzer',
  filetypes = 'rust',
  root_dir = function(path)
    local library_root = is_library(path)
    if library_root then return library_root end
    return project.find_rust_project_root(path)
  end,
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
}
