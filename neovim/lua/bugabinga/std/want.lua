--- attempts to import modules with the given names.
---@param module_names table name or list of names, or a function that returns those
---@return function function that takes a function that takes in the modules listed by `module_names`
return function(module_names)
  return function(block)
    local loaded_modules = {}
    local failed_modules = {}
    for _, name in pairs(module_names) do
      local status_ok, module = pcall(require, name)
      if status_ok then
        table.insert(loaded_modules, module)
      else
        table.insert(failed_modules, module)
      end
    end
    for _, module in pairs(failed_modules) do
      vim.notify('the required module ' .. module .. ' could not be found', 'error')
    end
    if #failed_modules > 0 then
      return
    end
    return block(unpack(loaded_modules))
  end
end
