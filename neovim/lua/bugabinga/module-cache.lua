-- usually i would use the `want` function here.
-- but impatient wants to override the require function as soon as possible
-- to get most out of the cache.
local ok, impatient = pcall(require, 'impatient')
if not ok then
  vim.notify('modules will not be cached, because `impatient` could not be found.', 'error')
  return
end
-- FIXME: enable profile only when neovim was startet with --startuptime?
impatient.enable_profile()
