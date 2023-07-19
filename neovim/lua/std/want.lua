--- attempts to import modules with the given names.
---@param module_names table name or list of names, or a function that returns those
---@return function function that takes a function that takes in the modules listed by `module_names`
return function(module_names)
  return function(block, error_handler)
    local loaded_modules = {}
    local failed_modules = {}
    if type(module_names) == "string" then
      module_names = { module_names }
    end
    for _, name in pairs(module_names) do
      local status_ok, module = pcall(require, name)
      if status_ok then
        table.insert(loaded_modules, module)
      else
        table.insert(failed_modules, module)
      end
    end
    for _, module in pairs(failed_modules) do
      vim.notify('A wanted module failed to load: ' .. module, 'error')
    end
    if #failed_modules > 0 then
      return error_handler and error_handler(unpack(failed_modules))
    end
    return block and block(unpack(loaded_modules))
  end
end