--- constant 'global' values
return {
  win32 = vim.loop.os_uname().sysname:match 'Win',
  wsl2 = vim.loop.os_uname().release:match 'WSL2',
}
