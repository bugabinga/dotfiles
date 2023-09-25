local table = require 'std.table'
local project = require 'std.project'

local create_shared_config_path = function(base_path, syntax_server)
  local os_config
  if vim.fn.has('linux') == 1 then
    os_config = syntax_server and 'config_linux' or 'config_ss_linux'
  elseif vim.fn.has('mac') == 1 then
    os_config = syntax_server and 'config_mac' or 'config_ss_mac'
  else
    os_config = syntax_server and 'config_win' or 'config_ss_win'
  end
  return vim.fs.joinpath(base_path, os_config)
end

local find_launcher_jar = function(base_path)
  local plugins_dir = vim.fs.joinpath(base_path, 'plugins')
  local launchers = vim.fn.globpath(plugins_dir, 'org.eclipse.equinox.launcher_*.jar', false, true)

  if table.is_empty(launchers) then
    vim.error('Could not find jdtls launcher jar in ' .. plugins_dir)
  end

  -- vim.print('found launcher jars', launchers)
  return launchers[1]
end

local create_data_dir = function()
  local cwd = vim.uv.cwd() or ''
  local data_name = vim.fn.sha256(cwd)
  local cache = vim.fn.stdpath 'cache'
  cache = type(cache) == 'table' and cache[1] or cache

  return vim.fs.joinpath(cache, 'jdtls_data', data_name)
end

local create_jdtls_command = function(syntax_server)
  local mason_packages_base_path = require 'mason-core.package':get_install_path()
  local jdtls_package_path = vim.fs.joinpath(mason_packages_base_path, 'jdtls')
  local shared_config_path = create_shared_config_path(jdtls_package_path, syntax_server)
  local launcher_jar = find_launcher_jar(jdtls_package_path)
  local data_dir = create_data_dir()

  local ss_option = syntax_server and '-Dsyntaxserver=true' or ''

  return {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=" .. shared_config_path,
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    ss_option,
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher_jar,
    '-data', data_dir,
  }
end

local find_jdks = function()
  local host = vim.uv.os_gethostname()
  local jdk11 = {
    name = "JavaSE-11",
  }
  local jdk17 = {
    name = "JavaSE-17",
  }
  local jdk19 = {
    name = "JavaSE-19",
  }

  if host == 'pop-os' then
    jdk11.path = '/usr/lib/jvm/openjdk-11'
    jdk17.path = '/usr/lib/jvm/openjdk-17'
    jdk19.path = '/usr/lib/jvm/openjdk-19'
  else
    vim.notify 'missing jdk paths in java settings for lsp'
  end

  return { jdk11, jdk17, jdk19 }
end

local java_settings = {
  signatureHelp = { enabled = true },
  sources = {
    organizeImports = {
      starThreshold = 9999,
      staticStarThreshold = 9999,
    },
  },
  configuration = { runtimes = find_jdks(), },
}

local jdtls_lsp_start = function(config, opts)
  -- vim.print('jdtls lsp start', config, opts)
  require 'jdtls'.start_or_attach(config, opts)
end

return {
  custom_start = jdtls_lsp_start,
  name = 'jdtls',
  filetypes = 'java',
  command = create_jdtls_command(true),
  root_dir = project.find_java_project_root,
  single_file_support = true,
  workspaces = false,
  settings = { java = java_settings },
}
