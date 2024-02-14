return {
  'jbyuki/instant.nvim',
  cmd = {
    'InstantStartSingle',
    'InstantJoinSingle',
    'InstantStartSession',
    'InstantJoinSession',
    'InstantStartServer',
  },
  init = function ()
    vim.g.instant_username = 'oli'
  end
}
