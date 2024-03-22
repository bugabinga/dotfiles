--FIXME: use map
return {
  'stevearc/qf_helper.nvim',
  ft = 'qf',
  cmd = { 'QNext', 'QPrev', 'QFToggle', 'QFOpen', 'LLToggle', },
  keys = {
    { ']q',        '<cmd>QNext<CR>',     mode = 'n', },
    { '[q',        '<cmd>QPrev<CR>',     mode = 'n', },
    { '<leader>q', '<cmd>QFToggle!<CR>', mode = 'n', },
    { '<leader>l', '<cmd>LLToggle!<CR>', mode = 'n', },
  },
  config = function ()
    require 'qf_helper'.setup {
      prefer_loclist = false,
    }
  end,
}
