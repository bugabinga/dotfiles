-- TODO: metatable for api like map.modes
-- Wrapper over `vim.api.nvim_create_autocmd` for automatic grouping and idempotency.
return function(group_name)
  local group = vim.api.nvim_create_augroup(group_name, { clear = true })
  return function(list_of_autocommands)
    if list_of_autocommands.events then
      list_of_autocommands = { list_of_autocommands }
    end
    for _, autocommand in pairs(list_of_autocommands) do
      -- command and callback are mutually exclusive.
      -- one of them has to be nil
      local command = nil
      local callback = nil
      if type(autocommand.command) == 'function' then
        callback = autocommand.command
      else
        command = autocommand.command
      end
      vim.api.nvim_create_autocmd(autocommand.events, {
        desc = autocommand.description,
        group = group,
        buffer = autocommand.buffer,
        pattern = autocommand.pattern,
        once = autocommand.once,
        command = command,
        callback = callback,
      })
    end
  end
end
