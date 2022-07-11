local want = require 'bugabinga.std.want'
want { 'hlslens' }(function(_)
  local noremap_silent = { noremap = true, silent = true }

  -- FIXME: hlslens uses some highlights, that my theme does not cover yet
  -- FIXME: use keymap facade
  -- FIXME: change commands to lua callbacks
  vim.api.nvim_set_keymap(
    'n',
    'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    noremap_silent
  )
  vim.api.nvim_set_keymap(
    'n',
    'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    noremap_silent
  )
  vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], noremap_silent)
  vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], noremap_silent)
  vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], noremap_silent)
  vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], noremap_silent)

  vim.api.nvim_set_keymap('n', '<LEADER><LEADER>', '<CMD>noh<CR>', noremap_silent)
end)
