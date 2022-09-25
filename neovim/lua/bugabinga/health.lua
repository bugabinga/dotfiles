-- use the neovim healthcheck module to integrate into :checkhealth.
-- check the system for dependencies, that:
-- * i like to use with neovim.
-- * plugins need.

local _ = {}

local function program_installed(name_of_executable)
	return (vim.fn.executable(name_of_executable) ~= 0)
end

local function check_program(name, name_of_executable)
	vim.health.report_start(name .. ' report')
	if program_installed(name_of_executable) then
		vim.health.report_ok(name_of_executable .. ' found on system')
	else
		vim.health.report_error(name .. ' is not installed on the system')
	end
end

_.check = function()
  check_program('ripgrep', 'rg')
  check_program('find-fd', 'fd')
  check_program('Nushell', 'nu')
  check_program('vim-startuptime', 'vim-startuptime')
  check_program('Pandoc', 'pandoc')
end

return _
