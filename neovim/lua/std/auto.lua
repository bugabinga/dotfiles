--- Wrapper over `vim.api.nvim_create_autocmd` for automatic grouping and idempotency.
--- @param group_name string name of the group of autocommands to define
--- @return function a function to add new autocommands to the defined group
return function ( group_name )
  local group = vim.api.nvim_create_augroup( group_name, { clear = true, } )
  --- adds new autocommands to the outer group
  --- @param list_of_autocommands table a single autocommand definition, or a list of those.
  return function ( list_of_autocommands )
    if list_of_autocommands.events then
      list_of_autocommands = { list_of_autocommands, }
    end
    for _, autocommand in pairs( list_of_autocommands ) do
      -- command and callback are mutually exclusive.
      -- one of them has to be nil
      local command = nil
      local callback = nil
      if type( autocommand.command ) == 'function' then
        callback = autocommand.command
      else
        command = autocommand.command
      end
      vim.api.nvim_create_autocmd( autocommand.events, {
        desc = autocommand.description,
        group = group,
        buffer = autocommand.buffer,
        pattern = autocommand.pattern,
        once = autocommand.once,
        command = command,
        callback = callback,
      } )
    end
  end
end
