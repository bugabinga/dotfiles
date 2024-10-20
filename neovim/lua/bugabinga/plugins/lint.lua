-- FIXME: own this
return {
  'mfussenegger/nvim-lint',
  commit = '968a35d54b3a4c1ce66609cf80b14d4ae44fe77f',
  ft = {
    'lua',
    'sh',
    'systemd',
    'editorconfig',
    'yaml',
  },
  opts = {
    linters_by_ft = {
      lua = { 'selene' },
      sh = { 'shellcheck', 'dotenv_linter' },
      systemd = { 'systemd-analyze' },
      editorconfig = { 'editorconfig-checker' },
      yaml = { 'yq' },
    },
    linters = {},
  },
  config = function ( _, opts )
    local lint = require 'lint'
    lint.linters_by_ft = opts.linters_by_ft
    for k, v in pairs( opts.linters ) do
      lint.linters[k] = v
    end
    ---@diagnostic disable-next-line: undefined-field
    local timer = assert( vim.uv.new_timer() )
    local DEBOUNCE_MS = 500
    local aug = vim.api.nvim_create_augroup( 'Lint', { clear = true } )
    vim.api.nvim_create_autocmd( { 'BufWritePost' }, {
      group = aug,
      callback = function ()
        local bufnr = vim.api.nvim_get_current_buf()
        timer:stop()
        timer:start( DEBOUNCE_MS, 0,
                     vim.schedule_wrap( function ()
                       if vim.api.nvim_buf_is_valid( bufnr ) then
                         vim.api.nvim_buf_call( bufnr, function () lint.try_lint( nil, { ignore_errors = true } ) end )
                       end
                     end )
        )
      end,
    } )
  end,
}
