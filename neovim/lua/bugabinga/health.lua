-- use the neovim healthcheck module to integrate into :checkhealth.
-- check the system for dependencies, that:
-- * i like to use with neovim.
-- * plugins need.

local check_parameter = require'std.check_parameter'

local _ = {}

local function program_installed(name_of_executable)
  return (vim.fn.executable(name_of_executable) ~= 0)
end

local function check_program(name, name_of_executable)
  local display_name = name and (name .. '(' .. name_of_executable .. ')') or name_of_executable
  vim.health.start(name .. ' report')
  if program_installed(name_of_executable) then
    vim.health.ok(display_name .. ' found on system')
  else
    vim.health.error(display_name .. ' is not installed on the system')
  end
end

local programs_to_check = {}

_.add_dependency = function(program)
	check_parameter(program, 'add_program', 'program', 'table')
	check_parameter(program.name_of_executable, 'add_program', 'program.name_of_executable', 'string')

	if not programs_to_check[program] then
		table.insert(programs_to_check, program)
	end
	
	-- returns itself so that multiple programs can be chain-added
	return _.add_dependency
end

_.check = function()
	vim.iter(programs_to_check)
		:each(function(program)
			check_program(program.name, program.name_of_executable)
		end)
end

return _
