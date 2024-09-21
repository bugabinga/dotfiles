local wez = require 'wezterm'

return function ( cfg )
  cfg.launch_menu = {
    {
      label = 'E-Mail',
      args = { 'aerc', },
      cwd = wez.home_dir,
    },
    {
      label = 'Bottom',
      args = { 'btm', },
      cwd = wez.home_dir,
    },
    {
      label = 'Clock',
      args = { 'tclock', },
      cwd = wez.home_dir,
    },
    {
      label = 'Netscanner',
      args = { 'sudo', wez.home_dir .. '/.cargo/bin/netscanner', },
      cwd = wez.home_dir,
    },
    {
      label = 'Calc',
      args = { 'eva', },
      cwd = wez.home_dir,
    },
    {
      label = 'Units',
      args = { 'fend', },
      cwd = wez.home_dir,
    },
    {
      label = 'Files',
      args = { 'yazi', },
      cwd = wez.home_dir,
    }, }
end