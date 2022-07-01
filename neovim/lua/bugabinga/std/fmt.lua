-- wraps vim commands with : (<CMD>) and Enter (<CR>)
local function cmd(interactive_command)
  return '<CMD>' .. interactive_command .. '<CR>'
end

return {
  cmd = cmd,
}
