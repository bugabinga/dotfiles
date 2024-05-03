local table = require 'std.table'
local project = require 'std.project'
local auto = require 'std.auto'
local map = require 'std.map'

local find_jdks = function ()
  local host = vim.uv.os_gethostname()
  local jdk11 = {
    name = 'JavaSE-11',
  }
  local jdk17 = {
    name = 'JavaSE-17',
  }
  local jdk21 = {
    name = 'JavaSE-21',
  }

  if host == 'velma' then
    jdk11.path = '/usr/lib64/jvm/java-11-openjdk-11'
    jdk17.path = '/usr/lib64/jvm/java-17-openjdk-17'
    jdk21.path = '/usr/lib64/jvm/java-21-openjdk-21'
  elseif host == 'NB-00718' then
    jdk11.path = 'C:/Users/okr/scoop/apps/openjdk11/current'
    jdk17.path = 'C:/Users/okr/scoop/apps/openjdk17/current'
    jdk21.path = 'C:/Users/okr/scoop/apps/openjdk21/current'
  else
    vim.notify 'missing jdk paths in java settings for lsp'
  end

  return { jdk11, jdk17, jdk21, }
end

local java_settings = {
  signatureHelp = { enabled = true, },
  sources = {
    autobuild = { enabeld = true, },
    signatureHelp = { enabled = true, },
    saveActions = { origanizeImports = true, },
    organizeImports = {
      starThreshold = 9999,
      staticStarThreshold = 9999,
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value()}, ${otherMembers}}',
      },
      hashCodeEquals = { useJava7Objects = true, },
      useBlocks = true,
    },
    eclipse = { downloadSources = true, },
  },
  configuration = {
    updateBuildConfiguration = 'interactive',
    runtimes = find_jdks(),
  },
  maven = { downloadSources = true, },
  implementationsCodeLens = { enabled = true, },
  referencesCodeLens = { enabled = true, },
  references = { includeDecompiledSources = true, },
  inlayHints = { parameterNames = { enabled = 'all', }, },
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

local on_attach = function ()
  vim.lsp.codelens.refresh()
  auto 'refresh_codelens' {
    events = 'BufWritePost',
    description = 'Refreshes LSP CodeLens after java file is written.',
    pattern = '*.java',
    command = function () pcall( vim.lsp.codelens.refresh ) end,
  }
end

return {
  name = 'jdtls',
  filetypes = 'java',
  command = 'jdtls',
  root_dir = project.find_java_project_root,
  single_file_support = true,
  workspaces = true,
  settings = { java = java_settings, },
  on_attach = on_attach,
}
