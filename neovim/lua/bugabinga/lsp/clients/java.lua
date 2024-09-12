local project = require 'std.project'
local auto = require 'std.auto'

local java_settings = {
  signatureHelp = { enabled = true, },
  sources = {
    autobuild = { enabled = true, },
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
  },
  maven = { downloadSources = true, },
  implementationsCodeLens = { enabled = true, },
  referencesCodeLens = { enabled = true, },
  references = { includeDecompiledSources = true, },
  inlayHints = { parameterNames = { enabled = 'all', }, },
  format = { enabled = true, },
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
