-- Set up all my favorite keybindings and list them in my cheatsheet.
-- This module assumes a lot of pre configured state, i.e. already installed and enabled plugins.
-- The benefit of assembling all keybinds here is, that they are easy to find.
-- But unfortunataly, by collecting them here, they are placed "far" from their logical place, i.e. the plugins configuration.
return function(cheatsheet)
  -- Delegator over nvim_set_keymap, that sets some default options
  local map = function(mode, left_hand_side, right_hand_side, options)
    local default_options = { noremap = true, unique = true }
    if options then
      default_options = vim.tbl_extend('force', default_options, options)
    end
    vim.api.nvim_set_keymap(
      mode,
      left_hand_side,
      right_hand_side,
      default_options
    )
  end
  -- Let the <LEADER> key be <SPACE>
  vim.g.mapleader = ' '

  map('n', '<LEADER><F12>', [[<CMD>lua require('glow').glow('<f-args>')<CR>]])
  cheatsheet 'LEADER + F12 => Render Markdown Preview'

  map('n', '<LEADER><F9>', [[<CMD>tabnew ~/.config/nvim/init.lua<CR>]])
  cheatsheet 'LEADER + F9 => Open nvim configuration in a new tab!'

  map('n', '<LEADER><F10>', [[<CMD>PluginsSync<CR>]])
  cheatsheet 'LEADER + F10 => Sync nvim plugins configuration!'

  -- Change behaviour of :terminal to be less like a vim buffer and more what I am used to
  map('t', '<ESC>', '<C-\\><C-n>')
  map('t', '<C-w>', '<ESC><C-w>')

  -- Clear highlighted search results whenever ESC is hit
  map('n', '<ESC>', ':nohlsearch<CR>', { unique = false, silent = true })

  map('n', '<LEADER>b', [[<CMD>Telescope buffers<CR>]])
  cheatsheet 'LEADER + b => Select a buffer'
  map('n', '<LEADER>f', [[<CMD>Telescope file_browser<CR>]])
  cheatsheet 'LEADER + f => Select a file'
  map('n', '<LEADER>e', [[<CMD>NvimTreeToggle<CR>]])
  cheatsheet 'LEADER + e => Toggle file explorer'

  --Open up a URL under the cursor
  local opener_program = ''
  if vim.fn.has("mac") == 1 then
    opener_program = 'open'
  elseif vim.fn.has("unix") == 1 then
  opener_program = 'xdg-open'
  elseif vim.fn.has('win32') == 1 then
  opener_program = 'explorer'
  else
    -- What should we do on unknown platforms? We guess...
  opener_program = 'firefox'
  end
    map('n', 'gx', [[<CMD>lua require'spawn'(']] .. opener_program .. [[',{ vim.fn.expand('<cfile>') } )<CR>]])
    cheatsheet'gx => Open URL under cursor'
end
