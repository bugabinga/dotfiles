if vim.g.bugabinga_debug_mode == nil then
  vim.g.bugabinga_debug_mode = false
end

local function is_debug_mode()
  return vim.g.bugabinga_debug_mode
end

local function print_debug( message, ... )
  if is_debug_mode() then
    -- TODO: pipe messages into custom debug buffer and file
    vim.print( message, ... )
  end
end

local function toggle_debug_mode()
  vim.g.bugabinga_debug_mode = not vim.g.bugabinga_debug_mode
  vim.notify( 'Toggled debug mode to ' .. tostring( is_debug_mode() ) )
end

vim.api.nvim_create_user_command( 'Debug', toggle_debug_mode, {} )

return {
  print = print_debug,
  toggle = toggle_debug_mode,
  get = is_debug_mode,
}
