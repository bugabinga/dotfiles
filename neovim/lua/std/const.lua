local uname = vim.uv.os_uname()
local win32 = vim.uv.os_uname().sysname:match 'Win' and true or false
local wsl = vim.uv.os_uname().release:match 'WSL2' and true or false

local os_background = function ()
  -- Default value
  local background = 'light'
  -- First check whether we are on WSL or Windows
  if win32 or wsl then
    -- Check if 'reg.exe' is executable
    if vim.fn.executable 'reg.exe' ~= 0 then
      -- Execute command to check if the win32 appearance is set to Dark
      local appsUseLightTheme = vim.fn.system { 'reg.exe', 'Query',
        'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize', '/v', 'AppsUseLightTheme' }
      if not appsUseLightTheme:find '0x1' then
        background = 'dark'
      end
    end
    -- Check if 'busctl' is executable (part of systemd)
  elseif vim.fn.executable 'busctl' ~= 0 then
    -- Get the current color scheme from xdg-desktop-portal using busctl
    local result = vim.fn.system {
      'busctl', '--user', 'call', 'org.freedesktop.portal.Desktop', '/org/freedesktop/portal/desktop',
      'org.freedesktop.portal.Settings', 'ReadOne', 'ss', 'org.freedesktop.appearance', 'color-scheme',
    }
    -- The result is in the form of "v u 0" for light and "v u 1" for dark
    local color_scheme = result:match 'u%s+(%d+)'

    if color_scheme == '1' then
      background = 'dark'
    end
  end

  return background
end

return {
  uname = uname,
  win32 = win32,
  wsl = wsl,
  os_background = os_background(),
}
