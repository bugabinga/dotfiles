-- Prints the highlight group name of the syntax element under the cursor.
return function()
  local syntax_id = vim.fn.synID(vim.fn.line '.', vim.fn.col '.', 1)
  print(
    vim.fn.synIDattr(syntax_id, 'name')
      .. ' -> '
      .. vim.fn.synIDattr(vim.fn.synIDtrans(syntax_id), 'name')
  )
end
