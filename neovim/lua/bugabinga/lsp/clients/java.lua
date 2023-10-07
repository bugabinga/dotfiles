local table = require 'std.table'
local project = require 'std.project'
local want = require 'std.want'
local auto = require 'std.auto'
local map = require'std.map'

local create_shared_config_path = function ( base_path, syntax_server )
  local os_config
  if vim.fn.has 'linux' == 1 then
    os_config = syntax_server and 'config_ss_linux' or 'config_linux'
  elseif vim.fn.has 'mac' == 1 then
    os_config = syntax_server and 'config_ss_mac' or 'config_mac'
  else
    os_config = syntax_server and 'config_ss_win' or 'config_win'
  end
  return vim.fs.joinpath( base_path, os_config )
end

local find_launcher_jar = function ( base_path )
  local plugins_dir = vim.fs.joinpath( base_path, 'plugins' )
  local launchers = vim.fn.globpath( plugins_dir, 'org.eclipse.equinox.launcher_*.jar', false, true )

  if table.is_empty( launchers ) then
    error( 'Could not find jdtls launcher jar in ' .. plugins_dir )
  end

  -- vim.print('found launcher jars', launchers)
  return launchers[1]
end

local create_data_dir = function ()
  local cwd = vim.uv.cwd() or ''
  local data_name = vim.fn.sha256( cwd )
  local cache = vim.fn.stdpath 'cache'
  cache = type( cache ) == 'table' and cache[1] or cache

  return vim.fs.joinpath( cache, 'jdtls_data', data_name )
end

local function get_bundles()
  local mason_registry = require 'mason-registry'
  local java_debug = mason_registry.get_package 'java-debug-adapter'
  local java_test = mason_registry.get_package 'java-test'
  local java_debug_path = java_debug:get_install_path()
  local java_test_path = java_test:get_install_path()
  local bundles = {}
  --FIXME: refactor this!
  vim.list_extend( bundles,
                   vim.split(
                     vim.fn.glob( java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar' ), '\n' ) )
  vim.list_extend( bundles, vim.split( vim.fn.glob( java_test_path .. '/extension/server/*.jar' ), '\n' ) )
  return bundles
end

local create_jdtls_command = function ( syntax_server )
  local mason_packages_base_path = want 'mason-core.package' (
    function ( mason ) return mason:get_install_path() end,
    function () return '/home/oli/Programs' end
  )

  local jdtls_package_path = vim.fs.joinpath( mason_packages_base_path, 'jdtls' )
  local shared_config_path = create_shared_config_path( jdtls_package_path, syntax_server )
  local launcher_jar = find_launcher_jar( jdtls_package_path )
  local data_dir = create_data_dir()

  local ss_option = syntax_server and '-Dsyntaxserver=true' or nil

  local command = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Dosgi.checkConfiguration=true',
    '-Dosgi.sharedConfiguration.area=' .. shared_config_path,
    '-Dosgi.sharedConfiguration.area.readOnly=true',
    '-Dosgi.configuration.cascaded=true',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher_jar,
    '-data', data_dir,
  }

  if ss_option then
    -- insert option after 'java'
    table.insert( command, 2, ss_option )
  end

  return command
end

local find_jdks = function ()
  local host = vim.uv.os_gethostname()
  local jdk11 = {
    name = 'JavaSE-11',
  }
  local jdk17 = {
    name = 'JavaSE-17',
  }
  local jdk19 = {
    name = 'JavaSE-19',
  }
  local jdk21 = {
    name = 'JavaSE-21',
  }

  if host == 'pop-os' then
    jdk11.path = '/usr/lib/jvm/java-11-openjdk-amd64'
    jdk17.path = '/usr/lib/jvm/java-17-openjdk-amd64'
    jdk19.path = '/usr/lib/jvm/java-19-openjdk-amd64'
    jdk21.path = '/home/oli/.jdks/openjdk-21'
  else
    vim.notify 'missing jdk paths in java settings for lsp'
  end

  return { jdk11, jdk17, jdk19, jdk21 }
end

local java_settings = {
  signatureHelp = { enabled = true },
  sources = {
    autobuild = { enabeld = true },
    signatureHelp = { enabled = true },
    saveActions = { origanizeImports = true },
    organizeImports = {
      starThreshold = 9999,
      staticStarThreshold = 9999,
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value()}, ${otherMembers}}',
      },
      hashCodeEquals = { useJava7Objects = true },
      useBlocks = true,
    },
    eclipse = { downloadSources = true },
  },
  configuration = {
    updateBuildConfiguration = 'interactive',
    runtimes = find_jdks(),
  },
  maven = { downloadSources = true },
  implementationsCodeLens = { enabled = true },
  referencesCodeLens = { enabled = true },
  references = { includeDecompiledSources = true },
  inlayHints = { parameterNames = { enabled = 'all' } },
  format = {
    enabled = true,
    -- TODO: set these here with my preferred settings
    -- set these on a project level -> read intellij /eclipse settings?
    -- settings = {
    --   url = 'TODO',
    --   profile = 'TODO',
    -- },
  },
}

local jdtls_lsp_start = function ( config, opts )
  -- vim.print('jdtls lsp start', config, opts)
  require 'jdtls'.start_or_attach( config, opts )
end

local get_extended_capabilites = function ()
  local ext = require 'jdtls'.extendedClientCapabilities
  ext.resolveAdditionalTextEditsSupport = true
  return ext
end

-- TODO:
local on_attach = function ()
  local jdtls = require 'jdtls'
  vim.lsp.codelens.refresh()
  jdtls.setup_dap { hotcodereplace = 'auto' }
  require 'jdtls.dap'.setup_dap_main_class_configs()
  require 'jdtls.setup'.add_commands()

  map.normal {
    description = 'Organize Imports',
    category = 'jdlts',
    keys = '<leader>ljo',
    command = jdtls.organize_imports,
  }

  map.normal {
    description = 'Extract Variable',
    category = 'jdlts',
    keys = '<leader>ljv',
    command = jdtls.extract_variable,
  }

  map.normal {
    description = 'Extract Constant',
    category = 'jdlts',
    keys = '<leader>ljc',
    command = jdtls.extract_constant,
  }

  map.normal {
    description = 'Test Nearest Method',
    category = 'jdlts',
    keys = '<leader>ljt',
    command = jdtls.test_nearest_method,
  }

  map.normal {
    description = 'Test Class',
    category = 'jdlts',
    keys = '<leader>ljT',
    command = jdtls.test_class,
  }

  map.normal {
    description = 'Update Config',
    category = 'jdlts',
    keys = '<leader>lju',
    command = '<cmd>JdtUpdateConfig<cr>',
  }

  map.visual {
    description = 'Extract Variable',
    category = 'jdlts',
    keys = '<leader>ljv',
    command = function() jdtls.extract_variable(true) end,
  }

  map.visual {
    description = 'Extract Constant',
    category = 'jdlts',
    keys = '<leader>ljc',
    command = function() jdtls.extract_constant(true) end,
  }

  map.visual {
    description = 'Extract Method',
    category = 'jdlts',
    keys = '<leader>ljm',
    command = function() jdtls.extract_method(true) end,
  }

  auto 'refresh_codelens' {
    events = 'BufWritePost',
    description = 'Refreshes LSP CodeLens after java file is written.',
    pattern = '*.java',
    command = function () pcall( vim.lsp.codelens.refresh ) end,
  }
end

return {
  name = 'jdtls',
  custom_start = jdtls_lsp_start,
  filetypes = 'java',
  command = create_jdtls_command( false ),
  root_dir = project.find_java_project_root,
  single_file_support = true,
  workspaces = true,
  settings = { java = java_settings },
  on_attach = on_attach,
  init_options = {
    bundles = get_bundles(),
    extendedClientCapabilities = get_extended_capabilites(),
  }
}
