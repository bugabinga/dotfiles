local debug = require 'std.debug'
local map = require 'std.map'

local format = function ()
  require 'conform'.format( { async = false, lsp_fallback = true, }, function ( err )
    if err and debug.get() then
      vim.print( 'Format failed', err )
    end
  end )
end

map.N {
  description = 'Format buffer',
  category = 'format',
  keys = '=',
  command = format,
}

--TODO: make user command Format
vim.api.nvim_create_user_command( 'Format', format, {} )

return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo', },
  opts = {
    formatters_by_ft = {
      -- https://github.com/razziel89/mdslw/issues/14
      markdown = { 'mdslw', },
      -- lua = { "stylua" },
      toml = { 'taplo', },
      sh = { 'shfmt', },
      just = { 'just', },
      zig = { 'zigfmt', },
      -- Use the "*" filetype to run formatters on all filetypes.
      ['*'] = { 'injected', 'typos', },
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ['_'] = { 'trim_whitespace', 'trim_newlines', },
    },
    formatters = {
      mdslw = {
        -- remove `:` from the default set of end markers
        -- prepend_args = { '--end-markers', '?!.', },
      },
    },
    log_level = debug.get() and vim.log.levels.TRACE or vim.log.levels.INFO,
  },
  init = function ()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
