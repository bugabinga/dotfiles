-- FIXME: own this
return {
  'johmsalas/text-case.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', },
  config = function ()
    require 'textcase'.setup {}
    require 'telescope'.load_extension 'textcase'
  end,
  keys = {
    'ga', -- Default invocation prefix
    { 'gA', '<cmd>TextCaseOpenTelescope<CR>', mode = { 'n', 'x', }, desc = 'Change text case', },
  },
  cmd = {
    'TextCaseOpenTelescope',
    'TextCaseOpenTelescopeQuickChange',
    'TextCaseOpenTelescopeLSPChange',
    'TextCaseStartReplacingCommand',
  },
}
