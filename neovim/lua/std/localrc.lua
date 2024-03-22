return function ( file_name )
  local filepath = vim.fn.fnamemodify( file_name, ':p' )
  local file = vim.secure.read( filepath )
  if not file then
    return {}
  end
  return loadstring( file )()
end
