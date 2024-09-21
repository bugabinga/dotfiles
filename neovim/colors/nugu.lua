-- TODO: move this to std and refactor to retun bool
-- Set color theme to light/dark based on current system preferences.
function get_background_based_on_os()
  -- Default value
  local background = 'light'
  local uname = vim.uv.os_uname()
  -- First check whether we are on WSL or Windows
  if uname.sysname == "Windows_NT" or string.match(uname.release, "WSL") then
    -- Check if 'reg.exe' is executable
    if vim.fn.executable('reg.exe') ~= 0 then
      -- Execute command to check if the win32 appearance is set to Dark
      local appsUseLightTheme = vim.fn.system({"reg.exe", "Query", "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize", "/v", "AppsUseLightTheme"})
      if not appsUseLightTheme:find("0x1") then
        background = 'dark'
      end
    end
  -- Check if 'busctl' is executable (part of systemd)
  elseif vim.fn.executable('busctl') ~= 0 then
    -- Get the current color scheme from xdg-desktop-portal using busctl
    local result = vim.fn.system({
      "busctl", "--user", "call", "org.freedesktop.portal.Desktop", "/org/freedesktop/portal/desktop",
      "org.freedesktop.portal.Settings", "ReadOne", "ss", "org.freedesktop.appearance", "color-scheme"
    })
    -- The result is in the form of "v u 0" for light and "v u 1" for dark
    local color_scheme = result:match("u%s+(%d+)")

    if color_scheme == '1' then
      background = 'dark'
    end
  else
  end

  return background
end

if vim.g.colors_name == nil then
  vim.opt.background = get_background_based_on_os()
else
  -- Reset all highlights if another colorscheme was previously set
  vim.cmd [[ highlight clear ]]
end

vim.g.colors_name = 'nugu'

-- this is necessary to toggle light/dark during runtime
package.loaded['bugabinga.nugu'] = nil
package.loaded['bugabinga.nugu.palette'] = nil

require 'bugabinga.nugu' ()
