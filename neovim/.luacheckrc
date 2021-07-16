-- vim: ft=lua tw=80
stds.nvim = {
  read_globals = { 'jit' },
}
std = 'lua51+nvim'
self = false
ignore = {
  -- max_line_length
  '631',
  -- unused argument, for vars with "_" prefix
  '212/_.*',
  '241/_.*',
}
globals = {
  'cheatsheet',
}
read_globals = {
  vim = {
    other_fields = true,
    fields = {
      g = {
        read_only = false,
        other_fields = true,
      },
    },
  },
}
files['.luacheckrc'] = { only = { '1' } }
