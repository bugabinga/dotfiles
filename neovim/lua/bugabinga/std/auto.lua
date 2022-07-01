-- Wrapper over `vim.api.nvim_create_autocmd` for automatic grouping and idempotency.
return function(group_name)
  local group = vim.api.nvim_create_augroup(group_name, { clear = true })
  return function(list_of_autocommands)
    if list_of_autocommands.events then
      list_of_autocommands = { list_of_autocommands }
    end
    for _, autocommand in pairs(list_of_autocommands) do
      vim.api.nvim_create_autocmd(autocommand.events, {
        desc = autocommand.description,
        group = group,
        pattern = autocommand.pattern,
        -- command and callback are mutually exclusive.
        -- one of them has to be nil
        command = autocommand.command,
        callback = autocommand.callback,
      })
    end
  end
end
