return {
  'smjonas/inc-rename.nvim',
  cmd = 'IncRename',
  keys = { {
    '<F2>',
  function()
      return ':IncRename ' .. vim.fn.expand('<cword>')
    end,
    desc = 'lsp: Rename symbol under cursor with live preview',
    expr = true,
  } },
  opts = {},
}
