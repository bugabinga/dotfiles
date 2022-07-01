-- TODO: add kool conceals for java syntax
-- https://github.com/alok/python-conceal/blob/master/after/syntax/python.vim
vim.opt_local.conceallevel = 2

local want = require 'bugabinga.std.want'
want {
  'jdtls',
  'lsp-zero',
  'nvim-lsp-installer',
}(function(jdtls, zero, installer)
  local debug_log = true
  local syntax_server = false
  local project = require 'bugabinga.std.project'

  local home = vim.fn.glob('~', false, false)
  local jdtls_root_dir = project.determine_java_project_root(home)
  if jdtls_root_dir then
    vim.notify('eclipse.jdt.ls java project root is ' .. jdtls_root_dir)
    -- even when a project root as found, it does not necessarily mean it is a
    -- `classic` java project, in the sense that eclipse.jdt.ls thinks of a "project"
    if not project.is_java_project_root(jdtls_root_dir, home) then
      -- support for single file mode
      syntax_server = true
    end
  else
    vim.notify('no root directory for eclipse.jdt.ls could be found.', 'warning')
    -- support for single file mode
    syntax_server = true
  end

  if syntax_server then
    vim.notify 'starting eclipse.jdt.ls in syntaxserver mode'
  end

  -- TODO: refactor most jdtls setup into module
  -- TODO: is there stuf that can be cached here?
  -- profile this file
  local installed, jdtls_installer = installer.get_server 'jdtls'
  if not installed then
    vim.notify('jdtls is not installed!', error)
    return
  end
  local jdtls_install_dir = jdtls_installer.root_dir
  local jdtls_config_dir = nil
  local jdtls_syntax_server_config_dir = nil
  if vim.fn.has 'mac' == 1 then
    jdtls_config_dir = jdtls_install_dir .. '/config_mac'
    jdtls_syntax_server_config_dir = jdtls_install_dir .. '/config_ss_mac'
  elseif vim.fn.has 'unix' == 1 then
    jdtls_config_dir = jdtls_install_dir .. '/config_linux'
    jdtls_syntax_server_config_dir = jdtls_install_dir .. '/config_ss_linux'
  elseif vim.fn.has 'win32' == 1 then
    jdtls_config_dir = jdtls_install_dir .. '/config_win'
    jdtls_syntax_server_config_dir = jdtls_install_dir .. '/config_ss_win'
  else
    vim.notify('eclipse.jdt.ls cannot be configured for current system.', 'error')
    return
  end

  local project_directory
  if jdtls_root_dir ~= nil then
    project_directory = jdtls_root_dir
  else
    project_directory = vim.fn.getcwd()
  end
  local project_name = vim.fn.fnamemodify(project_directory, ':p:h:t')
  local nvim_data = vim.fn.stdpath 'data'
  local jdtls_workspace_dir = nvim_data .. '/eclipse.jdt.ls.workspace/' .. project_name
  vim.fn.mkdir(jdtls_workspace_dir, 'p')

  local shared_configuration
  if syntax_server then
    shared_configuration = jdtls_syntax_server_config_dir
  else
    shared_configuration = jdtls_config_dir
  end
  --FIXME: sometimes the jdtls cannot start (code 13).
  -- it seems to have to do with invalif configuration "config_linux" and/or "~/.config/jdtls"
  local jdtls_command = {
    'java',
    '-Dsyntaxserver=' .. tostring(syntax_server),
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    -- '-Dosgi.checkConfiguration=true',
    -- '-Dosgi.sharedConfiguration.area=' .. shared_configuration,
    -- '-Dosgi.sharedConfiguration.area.readOnly=true',
    -- '-Dosgi.configuration.cascaded=true',
    '-Dlog.protocol=' .. tostring(debug_log),
    '-Dlog.level=ALL',
    --TODO: switch to ZGC
    '-XX:+UseParallelGC',
    '-XX:GCTimeRatio=4',
    '-XX:AdaptiveSizePolicyWeight=90',
    '-Dsun.zip.disableMemoryMapping=true',
    '-Djava.import.generatesMetadataFilesAtProjectRoot=false',
    '-Xmx4G',
    '-Xms100m',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    vim.fn.glob(jdtls_install_dir .. '/plugins/org.eclipse.equinox.launcher_*.jar', false, false),
    '-configuration',
    -- vim.fn.expand('~/.config/jdtls', false, false),
    shared_configuration,
    '-data',
    jdtls_workspace_dir,
  }

  -- FIXME: what's this? necessary?
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local server_trace = 'off'
  if debug_log then
    server_trace = 'verbose'
  end

  -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
  local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = jdtls_command,

    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = jdtls_root_dir,

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {
        autobuild = true,
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          generateComments = true,
          hashCodeEquals = { useJava7Objects = true, useInstanceOf = true },
          -- insertionLocation = '',
          toString = {
            listArrayContents = true,
            skipNullValues = false,
          },
          useBlocks = true,
        },
        completion = {
          enabled = true,
          favoriteStaticMembers = {
            'org.hamcrest.MatcherAssert.assertThat',
            'org.hamcrest.Matchers.*',
            'org.hamcrest.CoreMatchers.*',
            'org.junit.jupiter.api.Assertions.*',
            'java.util.Objects.requireNonNull',
            'java.util.Objects.requireNonNullElse',
            'org.mockito.Mockito.*',
          },
          filteredTypes = {
            'com.sun.*',
            'java.awt.*',
            'sun.*',
          },
          guessMethodArguments = false,
          importOrder = {
            'java',
            'javax',
            'javafx',
            'com',
            'org',
            'de',
            'net',
          },
          overwrite = false,
        },
        configuration = {

          --FIXME: configure platforms per host
          runtimes = {
            {
              name = 'JavaSE-1.8',
              path = '/usr/lib/jvm/java-8-openjdk-amd64',
            },
            {
              name = 'JavaSE-11',
              path = '/usr/lib/jvm/java-11-openjdk-amd64',
            },
            {
              name = 'JavaSE-17',
              path = '/usr/lib/jvm/java-17-openjdk-amd64',
              default = true,
            },
          },
          updateBuildConfiguration = 'automatic',
        },
        eclipse = { downloadSources = true },
        errors = { incompleteClasspath = { severity = 'warning' } },
        foldingRange = false,
        format = {
          enabled = true,
          onType = false,
        },
        implementationsCodeLens = true,
        inlayhints = { parameterNames = true },
        maven = { downloadSources = true, updateSnapshots = false },
        maxConcurrentBuilds = 8,
        referenceCodeLens = true,
        rename = true,
        saveActions = { organizeImports = true },
        selectionRange = true,
        signatureHelp = true,
        trace = { server = server_trace },
      },
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
      -- TODO: integrate debug and test extensions. can those be installed via paq, even though they are not vim plugins?
      bundles = {},
      extendedClientCapabilities = extendedClientCapabilities,
    },
    flags = {
      debounce_text_changes = 80,
      allow_incremental_sync = true,
    },
  }
  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  local merged_config = zero.build_options('jdtls', config)
  jdtls.start_or_attach(merged_config)
end)
