local path = vim.fn.stdpath 'data' .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.filewritable(path) == 0 then
  vim.fn.system {
    'git',
    'clone',
    '--depth=1',
    'https://github.com/savq/paq-nvim.git',
    path,
  }
  vim.cmd 'packadd paq-nvim'
end
return (require 'paq')
